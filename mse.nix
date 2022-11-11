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

  nativeBuildInputs = [
    pkgs.binutils
    pkgs.cmake
    pkgs.gpp
    pkgs.imagemagick
  ];

  buildInputs = [
    pkgs.pkg-config
    pkgs.boost
    pkgs.hunspell
    pkgs.wxGTK30-gtk3
  ];

  configurePhase = ''
    mkdir -p build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    cd ..
  '';

  buildPhase = ''
    cd build
    make -j$(nproc)
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/usr/{bin,lib}

    cp build/magicseteditor $out/usr/bin/

    ldd build/magicseteditor | awk "NF == 4 { system( \"cp \" \$3 \" $out/usr/lib/\" ) }"

    convert resource/icon/app.ico $out/magicseteditor.png
    cp $out/magicseteditor-3.png $out/magicseteditor.png
    rm -rf $out/magicseteditor-*.png
  '';
}
