{ config, pkgs, ... }:
let
  default_nix = pkgs.writeTextFile {
    name = "default.nix";
    text = ''
      with import <nixpkgs> {};
      mkShell {
        nativeBuildInputs = [
          bashInteractive
        ];
      }
    '';
  };
  flakify = pkgs.writeShellScriptBin "flakify" ''
    if [ ! -e flake.nix ]; then
      nix flake new -t github:nix-community/nix-direnv .
    elif [ ! -e .envrc ]; then
      echo "use flake" > .envrc
      direnv allow
    fi
    ''${EDITOR:-vim} flake.nix 
  '';
  nixify = pkgs.writeShellScriptBin "nixify" ''
    if [ ! -e ./.envrc ]; then
      echo "use nix" > .envrc
      direnv allow
    fi
    if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
      cp ${default_nix} default.nix
      ''${EDITOR:-vim} default.nix
    fi
  '';
in
{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  home.packages = [
    flakify
    nixify
  ];
}
