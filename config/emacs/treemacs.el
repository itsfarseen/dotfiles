(use-package all-the-icons)
(use-package treemacs)
(use-package treemacs-evil
  :config
  (evil-define-key nil 'global
    (kbd "<leader>e") 'treemacs-select-window
    (kbd "<leader>E") 'treemacs))
