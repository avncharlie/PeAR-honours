import re
import sys

if __name__ == '__main__':
    print('----------------------------------------')

    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} assembly.s out_folder")
        exit()

    assembly_file = sys.argv[1]
    out_folder = sys.argv[2]

    assembly = []
    with open(assembly_file) as f:
        for line in f:
            assembly.append(line.rstrip())

    re_function_start = r'^\W*\.type.*function'
    re_function_end = r'^\W*\.cfi_endproc'
    re_cfi_directive = r'^\W*\.cfi'
    re_rodata_start = r'^\W*\.section\W*\.rodata'
    re_type_directive= r'^\W*\.type'
    re_text_section= r'^\W*\.text'
    re_align_directive= r'^\W*\.align'
    re_string= r'^\W*\.string\W*"(.*)"$'

    total_rodata_len = 0

    i = 0
    patch_no = 0
    while i < len(assembly):

        if re.match(re_function_start, assembly[i]):
            func_name = assembly[i+1][:-1]
            func_index = i

            # retrieve function read only data
            func_rodata = []
            found_rodata = False
            while i > 0:
                # Skip text section start (from function we just found)
                # Skip type directives
                # Skip alignment (we have to calculate alignment ourselves as
                # gtirb doesn't support it)
                if not re.match(re_type_directive, assembly[i]) \
                    and not re.match(re_text_section, assembly[i]) \
                    and not re.match(re_align_directive, assembly[i]):

                    func_rodata.append(assembly[i])

                # Tally up string lengths
                # this is so we know how much data we are adding to rodata
                # so we can align it later
                re_res = re.match(re_string, assembly[i])
                if re_res:
                    s = re_res.group(1)
                    # newlines are read 2 chars but are just 1, fix
                    s = s.replace('\\n', '\n')
                    # add 1 for null terminator
                    total_rodata_len += len(s)+1

                if re.match(re_rodata_start, assembly[i]):
                    found_rodata = True
                    break

                if re.match(re_function_end, assembly[i]):
                    break
                i -= 1
            func_rodata.reverse()
            if not found_rodata:
                func_rodata = []

            # retrieve function code
            func_code = []
            i = func_index + 2
            while not re.match(re_function_end, assembly[i]):
                # leave out cfi directives
                if not re.match(re_cfi_directive, assembly[i]):
                    func_code.append(assembly[i])
                i += 1

            out_file = f'{out_folder}/{patch_no}-{func_name}.s'
            patch_no += 1

            print(f"Creating {out_file}")
            with open(out_file, 'w') as f:
                f.write('\n'.join(func_code + ['\n'] + func_rodata))

        i += 1

    # record rodata bytes for alignment info
    out_file = f'{out_folder}/added_bytes_rodata'
    print(f'Added {total_rodata_len} bytes to .rodata (stored in {out_folder}/added_bytes_rodata)')
    with open(out_file, 'w') as f:
        f.write(str(total_rodata_len))

    print('----------------------------------------')

