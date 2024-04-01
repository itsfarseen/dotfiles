(use-package vertico
  :config
  (vertico-mode)
  (vertico-grid-mode))

(use-package consult
  :config
  (evil-define-key 'normal 'global
    (kbd "C-p") 'consult-fd))

(use-package marginalia
  :init
  (marginalia-mode))
