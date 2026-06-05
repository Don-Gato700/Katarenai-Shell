#ifndef SHELL_H
#define SHELL_H

#define MAX_ARGS 64
#define MAX_BUFFER 1024

// Prototipos de funciones
void parse_input(char *buffer, char **args);
int execute_command(char **args);
int execute_builtin(char **args);

#endif