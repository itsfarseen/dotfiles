{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-x";
    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      # vi:foldmethod=marker
      set -g default-terminal xterm-256color
      set -ga terminal-overrides ",*256col*:Tc"
      set -g default-command "exec $SHELL"
      # set-window-option -g mode-keys vi

      set -sg escape-time 0 # To prevent tmux from delaying Vim ESC


      set-option -g status-position top
      # set -g status-left "#S (#(pwd)) "
      set -g status-left "  #[fg=red]#S  "
      set -g status-right "#T  #[fg=green]#(pwd)  #[fg=red]%c"
      set-option -g status-bg "#24283b"
      set-option -g status-fg "#d2a6ff"

      set -g status-justify left
      set -g status-left-length 85
      set -g status-right-length 200

      set-option -g mouse on
      set -g base-index 1
      set -g pane-base-index 1

      set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"

      bind-key -n C-b set-option status

      # {{{ Pane navigation

        bind-key -n 'M-h' select-pane -L
        bind-key -n 'M-j' select-pane -D
        bind-key -n 'M-k' select-pane -U
        bind-key -n 'M-l' select-pane -R
        bind-key -n 'M-\' select-pane -l
        bind-key -n 'M-;' display-panes
        bind-key -n 'M-n' next-window
        bind-key -n 'M-p' previous-window
                
        bind-key -n 'C-M-h' resize-pane -L 5
        bind-key -n 'C-M-j' resize-pane -D 5
        bind-key -n 'C-M-k' resize-pane -U 5
        bind-key -n 'C-M-l' resize-pane -R 5

        bind-key -T copy-mode-vi 'M-h' select-pane -L
        bind-key -T copy-mode-vi 'M-j' select-pane -D
        bind-key -T copy-mode-vi 'M-k' select-pane -U
        bind-key -T copy-mode-vi 'M-l' select-pane -R
        bind-key -T copy-mode-vi 'M-\' select-pane -l

        bind-key -n 'M-H' split-pane -hb
        bind-key -n 'M-J' split-pane -v
        bind-key -n 'M-K' split-pane -vb
        bind-key -n 'M-L' split-pane -h

      # }}}

      bind-key -n M-c attach-session -c "#{pane_current_path}"
      bind-key -n M-[ copy-mode
    '';
  };
}
