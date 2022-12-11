{ config, pkgs, ... }:
{
  programs.bash.enable = true;
  programs.fish.enable = true;

  programs.bash.initExtra = "
    exec fish
  ";

  programs.fzf.enable = true;
  programs.starship.enable = true;
  programs.starship.settings = {
    git_metrics.disabled = false;
    git_commit.disabled = false;
    git_state.disabled = false;
    rust.disabled = true;
    nodejs.disabled = true;
    package.disabled = true;
    container.disabled = true;
  };

}

