OPTS = -ljack -lm -lpthread \
		 $(shell pkg-config --libs --cflags xcb) \
		 -I/usr/include/guile/2.2 -lguile-2.2 \
		 -std=c99 -Wall -g -D_POSIX_C_SOURCE
BIN = jcs

$(BIN): jcscheme.c
	gcc jcscheme.c $(OPTS) -o $(BIN)

clean:
	rm -f $(BIN)

re: clean $(BIN)
