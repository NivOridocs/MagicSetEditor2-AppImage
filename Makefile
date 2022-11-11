VERSION ?= 0

Packs = https://github.com/MagicSetEditorPacks

define sparseClone
	git clone --branch main --depth 1 --sparse $(1) $(2)
	cd $(2) ; git sparse-checkout init
	cd $(2) ; git sparse-checkout set $(3)
	cd $(2) ; git pull origin main
endef

.PHONY: build package clear

build: target/magicseteditor-x86_64.AppImage

package: build target/MagicSetEditor-Basic-AppImage.tar.gz target/MagicSetEditor-Simple-AppImage.tar.gz target/MagicSetEditor-Full-AppImage.tar.gz

clear:
	rm -rf target

# Build

target/magicseteditor-x86_64.AppImage: target/AppDir
	VERSION=$(VERSION) ARCH=x86_64 appimagetool $< $@
	chmod a+x $@

target/AppDir: AppDir target/Binary.AppDir target/Share.AppDir
	mkdir -p $@/usr/{bin,lib} $@/usr/share{fonts,magicseteditor}
	cp -r AppDir/* target/Binary.AppDir/* target/Share.AppDir/* $@/
	chmod -R a+rw $@

target/Binary.AppDir: mse.nix
	mkdir -p $(@D)
	nix-build $< --out-link $@

target/Share.AppDir: mse.share.nix
	mkdir -p $(@D)
	nix-build $< --out-link $@

# Package

target/MagicSetEditor-Basic-AppImage.tar.gz: target/magicseteditor-x86_64.AppImage target/Basic.HomeDir
	tar czf $@ --directory $(@D) --transform 's,$(word 2,$(^F)),$(<F).home,' $(^F)

target/Basic.HomeDir:
	mkdir -p $(@D)
	$(call sparseClone,$(Packs)/Basic-M15-Magic-Pack.git,$@/.magicseteditor,data)

target/MagicSetEditor-Simple-AppImage.tar.gz: target/magicseteditor-x86_64.AppImage target/Simple.HomeDir
	tar czf $@ --directory $(@D) --transform 's,$(word 2,$(^F)),$(<F).home,' $(^F)

target/Simple.HomeDir:
	mkdir -p $(@D)
	$(call sparseClone,$(Packs)/M15-Magic-Pack.git,$@/.magicseteditor,data)

target/MagicSetEditor-Full-AppImage.tar.gz: target/magicseteditor-x86_64.AppImage target/Full.HomeDir
	tar czf $@ --directory $(@D) --transform 's,$(word 2,$(^F)),$(<F).home,' $(^F)

target/Full.HomeDir:
	mkdir -p $(@D)
	$(call sparseClone,$(Packs)/Full-Magic-Pack.git,$@/.magicseteditor,data)
