(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  (evil-define-key 'normal 'global
    (kbd "<leader>sx") 'slime-eval-buffer
    (kbd "<leader>sv") 'slime-eval-macroexpand-inplace))
