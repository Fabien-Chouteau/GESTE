all: fontconvert makefont

CC     = gcc
CFLAGS = -Wall -I/usr/include/freetype2
LIBS   = -lfreetype


makefont::
	./makefonts.sh

fontconvert: fontconvert.c
	$(CC) $(CFLAGS) $< $(LIBS) -o $@

clean:
	rm -f fontconvert
