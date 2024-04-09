VERSION="0.2.0"
AUTHOR="Simon Hilchenbach"
YEAR="2016-2024"

macchanger: macchanger.c
	@clang -framework IOKit -framework CoreFoundation -o $@ $^ \
		-DVERSION='${VERSION}' \
		-DAUTHOR='${AUTHOR}'   \
		-DYEAR='${YEAR}'

.PHONY: install
install: macchanger
	@cp ./macchanger /usr/local/bin/macchanger
