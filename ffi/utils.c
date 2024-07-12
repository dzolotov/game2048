#include "stdlib.h"
#include "string.h"
#include "utils.h"

int power(int n) {
    if (n == 0) {
        return 1;
    } else {
        return 2 * power(n - 1);
    }
}

char *mergeStrings(char *prefix, char *content) {
    char *mem = malloc(strlen(prefix) + strlen(content) + 1);
    strcpy(mem, prefix);
    strcpy(mem + strlen(prefix), content);
    return mem;
}

void memory_free(char *mem) {
    free(mem);
}

void set_name(NativePerson *person, char *name) {
    person->name = name;
}

NativeFameEntry *first;

NativeFameEntry *getFirst() {
    return first;
}

void addFameEntry(NativeFameEntry *fameEntry) {
    if (!first) {
        first = fameEntry;
    } else {
        NativeFameEntry *current = first;
        //ищем последнюю запись связанного списка
        while (current->next) current = current->next;
        current->next = fameEntry;
    }
}

void clearFameEntries() {
    NativeFameEntry *current = first;
    while (current) {
        NativeFameEntry *local = current;
        current = current->next;
        free(local);
    }
}