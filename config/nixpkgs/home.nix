{ config, pkgs, ... }:
let
  # Create this file with the content "machine-name" (with the quotes).
  # Allowed values are the keys of `machine-specific`.
  machine-name = import ./machine-name.nix;
  machine-specific = {
    "hp-x2-11" = {
      home.username = "itsfarseen";
      home.homeDirectory = "/home/itsfarseen";
      home.packages = with pkgs; [
        lxappearance
        gnome.gnome-tweaks
        dolphin-emu
        glibcLocales
        lagrange
        foot
      ];
    };
    "zephyrus-g15-2021" = {
      home.username = "farseen";
      home.homeDirectory = "/home/farseen";
      home.packages = with pkgs; [
      ];
    };
  };
  machine-config = machine-specific.${machine-name};
in
{
  imports = [
    ./shells.nix
    ./aliases.nix
    ./tmux.nix
  ];

  home.username = machine-config.home.username;
  home.homeDirectory = machine-config.home.homeDirectory;

  home.packages = with pkgs; [
    direnv
    fd
    fish
    lua
    neovim

    # Need this for the treesitter parsers to work.
    # If you already had them compiled using non-nix gcc, you will have to
    # recompile them using nix's gcc.
    # Otherwise they will throw libstdc++.so.6 not found errors.
    # Remove ~/.local/share/nvim/site/pack/packer/start/nvim-treesitter/parser/*.so
    # and restart neovim to recompile the parsers.
    gcc

    ripgrep
    rnix-lsp
    tmux
    nix-index
    (nerdfonts.override { fonts = [ "FiraCode" "Iosevka" ]; })
    git
  ] ++ machine-config.home.packages;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
