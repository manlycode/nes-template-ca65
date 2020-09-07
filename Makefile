NINTACO_ZIP = Nintaco_bin_2020-05-01.zip
NINTACO_URL := https://nintaco.com/$(NINTACO_ZIP)

.PHONY: all
all: build/main.nes

build/main.nes: main.asm
	vendor/cc65/bin/cl65 \
		-o build/main.nes\
		--asm-include-dir vendor/cc65/asminc \
		--asm-include-dir vendor/cc65/libsrc \
		-L vendor/cc65/lib \
		-Ln build/main.labels \
		--listing build/main.listing \
		-t nes\
		-C nes.cfg \
		main.asm

.PHONY: clean
clean:
	-rm vendor/nintaco.zip
	-rm -f build/*.nes
	-rm -f build/*.labels
	-rm -f build/*.listing

.PHONY: clean-deps
clean-deps:
	-rm -rf vendor/*

.PHONY: bootstrap
bootstrap: vendor/cc65/bin/ca65 vendor/nintaco/Nintaco.jar

main.asm: assets/background.chr assets/sprite.chr

vendor:
	-mkdir vendor

# -------------------------------------------------------
# ca65
# -------------------------------------------------------
vendor/cc65: vendor
	git clone https://github.com/cc65/cc65.git vendor/cc65

vendor/cc65/bin/ca65: vendor/cc65
	pushd vendor/cc65; make; popd

# -------------------------------------------------------
# Nintaco
# -------------------------------------------------------
vendor/nintaco.zip: vendor
	curl -L $(NINTACO_URL) -o $@

vendor/nintaco: vendor
	-mkdir $@

vendor/nintaco/Nintaco.jar: vendor/nintaco vendor/nintaco.zip
	unzip -o vendor/nintaco.zip -d $<

# -------------------------------------------------------
# Tests
# -------------------------------------------------------
vendor/6502_test_executor: vendor
	git clone https://github.com/89erik/6502_test_executor.git vendor

vendor/6502_test_executor/6502_tester: vendor/6502_test_executor
	pushd @<; make; popd

