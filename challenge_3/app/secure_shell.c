#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

void login(){
    int is_admin = 0;
    char password[32];
    scanf("%s", password);

    // TODO: Add logic for confirming password
    // is_admin = strcmp(password, "TODO") == 0;
    if (is_admin == 1) {
        printf("Access granted\n");
        setuid(0);
        setgid(0);
        system("/bin/bash");
    } else {
        printf("Access denied\n");
    }
}

int main(int argc, char **argv) {
    printf("Please enter secure shell password:\n");
    login();
    return 0;
}
