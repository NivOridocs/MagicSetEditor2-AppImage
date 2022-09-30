#! /usr/bin/env nix-shell
#! nix-shell --pure -i bash -p binutils gpp cmake boost172 hunspell wxGTK30-gtk3 imagemagick
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/13cbe534ebe63a0bc2619c57661a2150569d0443.tar.gz

WORKDIR=`pwd`

cd MagicSetEditor2
mkdir -p build
cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DHUNSPELL_LIBRARIES=`find /nix/store -name "*libhunspell*so"`
cmake --build .

cd $WORKDIR

rm -rf AppDir/usr/bin AppDir/usr/lib
mkdir -p AppDir/usr/bin AppDir/usr/lib

# Install icon
if [ ! -f "AppDir/magicseteditor.png" ]
then
    convert ./MagicSetEditor2/resource/icon/app.ico ./AppDir/magicseteditor.png
    cp ./AppDir/magicseteditor-3.png ./AppDir/magicseteditor.png
    rm -rf ./AppDir/magicseteditor-*.png
fi

# Install binary
cp ./MagicSetEditor2/build/magicseteditor ./AppDir/usr/bin/

# Install library
ldd ./MagicSetEditor2/build/magicseteditor | grep -E 'boost|hunspell|wxwidget' | awk 'NF == 4 { system( "cp " $3 " AppDir/usr/lib/" ) }'
