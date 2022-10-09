{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/13cbe534ebe63a0bc2619c57661a2150569d0443.tar.gz";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "mse";
  version = "2.1.2";

  src = pkgs.fetchgit {
    url = "https://github.com/twanvl/MagicSetEditor2";
    rev = "f9d9356d51f28210ccf0c0dda508502f222e1def";
    sha256 = "sha256-c1FkurEWo3xswDxyI7wM6QcqA4AiIB9Wqe2PqFm+3jc=";
  };

  buildInputs = [
    pkgs.binutils
    pkgs.gpp
    pkgs.cmake
    pkgs.boost
    pkgs.hunspell
    pkgs.wxGTK30-gtk3
    pkgs.imagemagick
  ];

  configurePhase = ''
    mkdir -p build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DHUNSPELL_LIBRARIES=`find /nix/store -name "*libhunspell*so"`
    cd ..
  '';

  buildPhase = ''
    cd build
    cmake --build .
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/usr/bin $out/usr/lib

    cp build/magicseteditor $out/usr/bin/

    ldd build/magicseteditor | grep -E 'boost|hunspell|wxwidget' | awk "NF == 4 { system( \"cp \" \$3 \" $out/usr/lib/\" ) }"

    convert resource/icon/app.ico $out/magicseteditor.png
    cp $out/magicseteditor-3.png $out/magicseteditor.png
    rm -rf $out/magicseteditor-*.png
  '';
}
