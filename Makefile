CC = gcc
CFLAGS = -Wall -Wextra -Iinclude
SRC = src/main.c src/builtins.c src/parser.c src/utils.c
OBJ = $(SRC:.c=.o)
TARGET = katarenai

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

clean:
	rm -f src/*.o $(TARGET)