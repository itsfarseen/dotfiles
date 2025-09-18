(defun main ()
  (use-package evil
    :demand t
    :bind (("<escape>" . keyboard-escape-quit))
    :init
    (setq evil-want-keybinding nil
	  evil-move-beyond-eol t)
    :config
    (setup-evil))

  (use-package evil-commentary
    :config				
    (define-key evil-commentary-mode-map
		(kbd "M-/") 'evil-commentary-line)
    (evil-commentary-mode)))

(defun setup-evil ()
  (evil-mode 1)
  (evil-set-leader nil (kbd "C-SPC")) ; Ctrl Space as leader in insert mode
  (evil-set-leader 'motion (kbd "SPC")) ; Space as leader in motion mode which gets inherited by most other modes
  (setq evil-emacs-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-motion-state-modes nil)
  (evil-define-key nil 'global
    (kbd "C-s") 'save-buffer
    (kbd "<leader> l") 'windmove-right   
    (kbd "<leader> h") 'windmove-left
    (kbd "<leader> j") 'windmove-down
    (kbd "<leader> k") 'windmove-up
    (kbd "<leader> wl") 'my-split-window-right
    (kbd "<leader> wh") 'my-split-window-left
    (kbd "<leader> wj") 'my-split-window-below
    (kbd "<leader> wk") 'my-split-window-above
    (kbd "<leader> c") 'delete-window
    (kbd "<leader> x") 'kill-this-buffer
    (kbd "<leader> .") 'next-buffer
    (kbd "<leader> ,") 'previous-buffer
    (kbd "C--") 'default-text-scale-decrease
    (kbd "C-=") 'default-text-scale-increase))

(setq switch-to-prev-buffer-skip-regexp "\*[^*]+\*")

(defun my-split-window-right ()
  (interactive)
  (split-window-right)
  (windmove-right))

(defun my-split-window-left ()
  (interactive)
  (split-window-right))

(defun my-split-window-above ()
  (interactive)
  (split-window-below))

(defun my-split-window-below ()
  (interactive)
  (split-window-below)
  (windmove-down))

(main)
