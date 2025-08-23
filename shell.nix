{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ 
    pkgs.zsh
    pkgs.nim
  ];
  shellHook = ''
    export SHELL=${pkgs.zsh}/bin/zsh
  '';
}
