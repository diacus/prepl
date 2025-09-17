PACKAGE_NAME := $(shell awk -F': *' '/Package/ {print $$2}' manifest.txt)
PACKAGE_VERSION :=$(shell awk '/Version/ {print $$2}' manifest.txt)
ARTIFACT=$(PACKAGE_NAME)-$(PACKAGE_VERSION)
BUILD_ROOT=build
BUILD_DIR=$(BUILD_ROOT)/$(ARTIFACT)
MAN_PATH=$(BUILD_DIR)/usr/local/share/man/man1

deb: bin
	mkdir -p $(BUILD_DIR)/DEBIAN
	cp manifest.txt $(BUILD_DIR)/DEBIAN/control
	cd build; \
	dpkg-deb --root-owner-group --build $(ARTIFACT)
	dpkg -c $(BUILD_ROOT)/$(ARTIFACT).deb

bin: src/prepl.pl
	mkdir -p $(BUILD_DIR)/usr/local/bin
	install -m 755 src/prepl.pl $(BUILD_DIR)/usr/local/bin/prepl

clean:
	$(RM) -r $(BUILD_ROOT)

.PHONY: deb bin clean 
