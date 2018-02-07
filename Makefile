
CC := gcc
FLAGS := -Wall -g

redzone: main.c redzone.S
	$(CC) $(FLAGS) $^ -o $@

clean:
	rm -f redzone
	rm -rf redzone.dSYM
