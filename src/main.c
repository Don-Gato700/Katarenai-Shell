#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_ARGS 64

int main() {
    char buffer[1024];
    char *args[MAX_ARGS];

    while (1) {
        printf("Katarenai-Shell$ ");
        if (!fgets(buffer, 1024, stdin)) break;
        buffer[strcspn(buffer, "\n")] = 0;

        // Dividir la línea en argumentos
        int i = 0;
        args[i] = strtok(buffer, " ");
        while (args[i] != NULL && i < MAX_ARGS - 1) {
            args[++i] = strtok(NULL, " ");
        }
        args[i] = NULL; // Terminar el arreglo

        if (args[0] == NULL) continue;
        if (strcmp(args[0], "exit") == 0) break;

        pid_t pid = fork();
        if (pid == 0) {
            // Ahora usamos execvp, que sí acepta arreglos de argumentos
            execvp(args[0], args);
            perror("Error");
            exit(1);
        } else {
            wait(NULL);
        }
    }
    return 0;
}