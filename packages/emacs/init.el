; vi:ts=8:

; General config

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode 1)

(set-frame-font "Iosevka 12" nil t)

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

; Package System: Init
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(setq
 use-package-always-ensure t
 use-package-verbose t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

; Load config modules

(defun load-config (@relative-path)
  (let*
      ((current-file (or load-file-name buffer-file-name))
       (current-dir (file-name-directory current-file))
       (absolute-path (concat current-dir @relative-path)))
    (load absolute-path)))

(load-config "./evil.el")
(load-config "./theme.el")
(load-config "./focus.el")
(load-config "./slime.el")
(load-config "./treemacs.el")
(load-config "./text-scale.el")
(load-config "./completions.el")

; Packages

; (use-package lispy
;   :init
;   (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1))))
; 
; (use-package lispyville
;   :init
;   (add-hook 'lispy-mode-hook (lambda (lispyville-mode)))
;   :config
;   (lispyville-set-key-theme '(operators c-w additional)))
