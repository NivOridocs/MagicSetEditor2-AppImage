
Version ?= 2.1.2
Packs ?= https://github.com/MagicSetEditorPacks

define sparseClone
	mkdir -p target/git
	git clone --branch main --depth 1 --sparse $(1) $(2)
	cd $(2) ; git sparse-checkout init
	cd $(2) ; git sparse-checkout set $(3)
	cd $(2) ; git pull origin main
endef

.PHONY: build basic clear
build: basic

# Basic

basic: target/magicseteditor-$(Version)-basic-x86_64.AppImage

target/magicseteditor-$(Version)-basic-x86_64.AppImage: target/AppDir/basic
	VERSION=$(Version) ARCH=x86_64 appimagetool $< $@
	chmod +x $@

target/AppDir/basic: target/git/basic AppDir/ result
	mkdir -p $@/usr/bin $@/usr/lib $@/usr/share/fonts $@/usr/share/magicseteditor
	cp -uR AppDir/* result/* $@/
	cp -uR $</'Magic - Fonts'/* $@/usr/share/fonts/
	cp -uR $</data $</resource $@/usr/share/magicseteditor/
	cd $@/usr/share/magicseteditor/resource ; cp -u combine_* tool/

target/git/basic:
	$(call sparseClone,$(Packs)/Basic-M15-Magic-Pack.git,$@,'Magic - Fonts' data resource)

# Core

result: mse.nix
	nix-build mse.nix

# Clear

clear:
	rm -rf target
