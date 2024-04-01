(use-package default-text-scale
  :config
  (evil-define-key nil 'global
    (kbd "C--") 'default-text-scale-decrease
    (kbd "C-=") 'default-text-scale-increase))
