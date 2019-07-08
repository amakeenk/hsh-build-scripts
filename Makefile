PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin

install:
	install -m0755 build-rpm $(BINDIR)/build-rpm
	install -m0755 sandbox-init $(BINDIR)/sandbox-init
	install -m0755 last-build.py $(BINDIR)/last-build
