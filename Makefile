CC ?= clang
CFLAGS := -framework IOKit -framework CoreWLAN -framework CoreFoundation -framework Cocoa -mmacosx-version-min=10.12
prefix ?= /usr/local

VERSION="0.2.0"
AUTHOR="Simon Hilchenbach"
YEAR="2016-2026"

macchanger: macchanger.m
	$(CC) -o $@ $^ $(CFLAGS) \
		-DVERSION='${VERSION}' \
		-DAUTHOR='${AUTHOR}'   \
		-DYEAR='${YEAR}'

.PHONY: install
install: macchanger
	mkdir -p $(prefix)/bin
	cp ./macchanger $(prefix)/bin/macchanger

.PHONY: clean
clean:
	rm ./macchanger
