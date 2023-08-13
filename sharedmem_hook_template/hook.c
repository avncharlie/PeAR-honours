#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include "hook.h"

void __afl_rewrite_sharedmem_hook(struct x86_64_regs *regs, uint8_t *input_buf, uint32_t input_buf_len) {

    // reset
    memset(regs->rdi, 0, 100);

    if (input_buf_len > 100)
        input_buf_len = 100;

    memcpy(regs->rdi, input_buf, input_buf_len);

    /////////////////////////////

    //memset(regs->rdi, 0, 4096);

    //if (input_buf_len > 4096)
    //    input_buf_len = 4096;

    //memcpy(regs->rdi, input_buf, input_buf_len);
    //regs->rsi = input_buf_len;
}
