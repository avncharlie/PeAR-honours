#include <stdio.h>

int fib(int n) {
    int a = 0;
    int b = 1;
    int tmp;
    for (int x = 0; x < n; x++) {
        tmp = b;
        b = b + a;
        a = tmp;
    }
    return a;
}


int main() {
    for (int x = 0; x < 10; x++) {
        printf("fib(%d): %d\n", x, fib(x));
    }
}
