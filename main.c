#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    char buffer[1024];

    while (1) {
        printf("Katarenai-Shell$ ");
        if (!fgets(buffer, 1024, stdin)) break;
        
        buffer[strcspn(buffer, "\n")] = 0; // Quitar el salto de línea

        if (strcmp(buffer, "exit") == 0) break;
        if (strlen(buffer) == 0) continue;

        pid_t pid = fork();
        if (pid == 0) {
            // Proceso hijo: intenta ejecutar el comando
            execlp(buffer, buffer, NULL);
            // Si llega aquí es porque el comando falló
            printf("Comando no encontrado: %s\n", buffer);
            exit(1);
        } else {
            // Proceso padre: espera al hijo
            wait(NULL);
        }
    }
    return 0;
}