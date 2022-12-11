{ config, pkgs, ... }:
{
  home.shellAliases = {
    vim = "nvim";
    # git
    gs = "gst";
    gst = "git status";
    gc = "git commit";
    gcv = "git commit -v";
    gce = "git commit --amend";
    gcev = "git commit --amend -v";
    gps = "git push";
    gpsf = "git push -f";
    gpl = "git pull";
    gd = "git diff";
    gds = "git diff --staged";
    gr = "git rebase";
    gri = "git rebase -i";
    grc = "git rebase --continue";
    gra = "git rebase --abort";
    grs = "git rebase --skip";
    gl = "git log --graph --oneline";
    gla = "git log --graph --oneline --all";
    glg = "git log";
    # nix
    hms = "home-manager switch";
    nxsw = "sudo nixos-rebuild switch";
    nxs = "nix search nixpkgs";
    # cd
    cdg = "cd $(git rev-parse --show-toplevel)";
    # docker-compose
    dcu = "docker-compose up";
    dcud = "docker-compose up -d";
    dcd = "docker-compose down";
    dcdu = "docker-compose down && docker-compose up";
    dcl = "docker-compose logs";
    dclf = "docker-compose logs -f";
    # docker
    dps = "docker ps";
  };

  programs.fish.functions = {
    gdd = "git diff $argv[1]^ $argv[1]";
    gdh = "gdd HEAD";
    zg = ''
      if test (count $argv) -lt 2
        zb;
      else
        zb;
        zc $argv;
      end
    '';
  };

  programs.z-lua.enable = true;
  home.shellAliases = { 
    "zc" = "z -c"; # z but only under $PWD
    "zt" = "z -t"; # recent instead of frecent
    "zb" = "z -b"; # search backwards
  }; 
}
