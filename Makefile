NINTACO_ZIP = Nintaco_bin_2020-05-01.zip
NINTACO_URL := https://nintaco.com/$(NINTACO_ZIP)



.PHONY: clean
clean:
	rm vendor/nintaco.zip

.PHONY: clean-deps
clean-deps:
	-rm -rf vendor/*

.PHONY: bootstrap
bootstrap: vendor/cc65/bin/ca65 vendor/nintaco/Nintaco.jar

vendor:
	mkdir vendor

vendor/cc65: vendor
	git clone https://github.com/cc65/cc65.git vendor/cc65

vendor/cc65/bin/ca65: vendor/cc65
	pushd vendor/cc65; make; popd

vendor/nintaco.zip: vendor
	curl -L $(NINTACO_URL) -o $@

vendor/nintaco: vendor
	mkdir $@

vendor/nintaco/Nintaco.jar: vendor/nintaco.zip vendor/nintaco
	unzip -o $< -d $@
