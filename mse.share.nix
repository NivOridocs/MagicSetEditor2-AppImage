{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/13cbe534ebe63a0bc2619c57661a2150569d0443.tar.gz";
  }) {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "mse";
  version = "2.1.2";

  src = pkgs.fetchgit {
    url = "https://github.com/MagicSetEditorPacks/Basic-M15-Magic-Pack";
    rev = "b5eb3fad10b5f35e46fedc637052a3603c7b393c";
    sha256 = "sha256-XBOmxsOSZUNtDlJPgImTz2ClFsQsAx4+kHEtyHCW++Q=";
  };

  nativeBuildInputs = [
    pkgs.binutils
  ];

  configurePhase = ''
  '';

  buildPhase = ''
  '';

  installPhase = ''
    mkdir -p $out/usr/share/{fonts,magicseteditor}
    cp -r 'Magic - Fonts'/* $out/usr/share/fonts/
    cp -r resource $out/usr/share/magicseteditor/
    cd $out/usr/share/magicseteditor/resource
    cp -u combine_* tool/
  '';
}
