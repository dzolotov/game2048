int power(int);

char *mergeStrings(char *, char *);

void memory_free(char *);

typedef struct {
    char *salutation;
    char *name;
} NativePerson;

typedef struct {
    char *name;
    int score;
    void *next;     //linked list (cast to NativeFameEntry)
} NativeFameEntry;

void set_name(NativePerson *, char *);

NativeFameEntry *getFirst();

void addFameEntry(NativeFameEntry *entry);

void clearFameEntries();
