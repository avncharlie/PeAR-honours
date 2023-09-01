// modified from: https://github.com/AFLplusplus/AFLplusplus/blob/stable/utils/persistent_mode/persistent_demo.c

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <limits.h>

void test(char *buf) {
    printf("got: %s\n", buf);

    if (buf[0] == 'f') {
        printf("one\n");
        if (buf[1] == 'o') {
            printf("two\n");
            if (buf[2] == 'o') {
                printf("three\n");
                if (buf[3] == '!') {
                    printf("four\n");
                    if (buf[4] == '!') {
                        printf("five\n");
                        if (buf[5] == '!') {
                            printf("six\n");
                            abort();
                        }
                    }
                }
            }
        }
    }
}

void init() {
    usleep(50000);
}

void read_and_test_file(char *fname) {
    char buf[100]; 

    FILE *file = fopen(fname, "rb"); 
    if (file == NULL) {
        perror("Error opening file");
        exit(2);
    }
    size_t read_size = fread(buf, 1, 100, file);
    fclose(file);

    test(buf);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    init();

    read_and_test_file(argv[1]);
}
