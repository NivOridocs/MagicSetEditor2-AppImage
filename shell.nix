{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/13cbe534ebe63a0bc2619c57661a2150569d0443.tar.gz") {}}:

pkgs.mkShell {
  packages = [
    pkgs.appimagekit
  ];
}
