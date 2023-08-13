
new = ""

c = 0
with open("/tmp/test.S") as f:
    for line in f:
        if 'vpcmpnleuq' in line:
            line = line.replace('}', '').replace('{',',')

        new += line

with open("/tmp/fixup.S", 'w') as f:
    f.write(new)
