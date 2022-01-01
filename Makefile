all: dorsum

dorsum: main.cr src/**/*.cr
	shards
	crystal build --error-trace -o dorsum main.cr
	@strip dorsum
	@du -sh dorsum

clean:
	rm -rf .crystal dorsum .deps .shards libs lib *.dwarf build

PREFIX ?= /usr/local

install: dorsum
	install -d $(PREFIX)/bin
	install dorsum $(PREFIX)/bin