NAME=langfix
VERSION=0.0.1

7Z=7z
JQ=jq
SHA1SUM=sha1sum
ARCHIVE_NAME=$(NAME)-$(VERSION).zip
SOURCES=$(shell find -type f -not \
	\( -path './.gitignore' \
	   -o -path './.git/*' \
	   -o -path './build/*' \
	   -o -path './Makefile' \
	\) )

all: $(ARCHIVE_NAME)
	@echo $< is packed.

clean:
	@rm -r build '$(ARCHIVE_NAME)' || true

sha1: $(ARCHIVE_NAME)
	@$(SHA1SUM) '$<' | cut -d' ' -f1 >&2

%.zip: ./build $(addprefix ./build/,$(SOURCES))
	@cd build && $(7Z) a -tzip -mx0 -mmt0 -- ../'$@' .

./build/%.json: %.json
	@mkdir -p "$(shell dirname "$@")"
	$(JQ) -c <'$<' >'$@'

./build/%.mcmeta: %.mcmeta
	@mkdir -p "$(shell dirname "$@")"
	$(JQ) -c <'$<' >'$@'

./build/%.txt : %.txt
	@mkdir -p "$(shell dirname "$@")"
	cp '$<' '$@'

./build:
	mkdir "$@"
