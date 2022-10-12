all: dorsum

lib:
	shards

dorsum: lib main.cr src/**/*.cr
	crystal build --error-trace -o dorsum main.cr
	@strip dorsum
	@du -sh dorsum

release: lib main.cr src/**/*.cr
	crystal build --release -o dorsum main.cr
	@strip dorsum
	@du -sh dorsum

clean:
	rm -rf .crystal dorsum .deps .shards libs lib *.dwarf build

PREFIX ?= /usr/local

install: dorsum
	install -d $(PREFIX)/bin
	install dorsum $(PREFIX)/bin