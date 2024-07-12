#include "stdlib.h"
#include "string.h"

int power(int n) {
    if (n == 0) {
        return 1;
    } else {
        return 2 * power(n - 1);
    }
}

char *usePrefix(char *prefix, char *content) {
    char *mem = malloc(strlen(prefix) + strlen(content) + 1);
    strcpy(mem, prefix);
    strcpy(mem + strlen(prefix), content);
    return mem;
}

void memory_free(char *mem) {
    free(mem);
}