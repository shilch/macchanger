CC ?= clang
CFLAGS := -framework IOKit -framework CoreWLAN -framework CoreFoundation -framework Cocoa -mmacosx-version-min=10.12
prefix ?= /usr/local

VERSION="0.2.1"
AUTHOR="Simon Hilchenbach"
YEAR="2016-2026"
HOMEPAGE="https://github.com/shilch/macchanger"

macchanger: macchanger.m
	$(CC) -o $@ $^ $(CFLAGS) \
		-DVERSION='${VERSION}' \
		-DAUTHOR='${AUTHOR}'   \
		-DYEAR='${YEAR}'       \
		-DHOMEPAGE='${HOMEPAGE}'

.PHONY: install
install: macchanger
	mkdir -p $(prefix)/bin
	cp ./macchanger $(prefix)/bin/macchanger

.PHONY: clean
clean:
	rm ./macchanger
