;;------------------------------------------------------------------------------
;; General Configuration
;;------------------------------------------------------------------------------

(set-default-font "9x15")
(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)

;; Interface
(xterm-mouse-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(add-hook 'prog-mode-hook 'linum-mode)
(setq linum-format "%4d")
(global-hl-line-mode t)
(blink-cursor-mode 0)
(setq line-number-mode t)
(setq column-number-mode t)

;; Initialize
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)
    (package-initialize)))

(require 'use-package)

;;------------------------------------------------------------------------------
;; Packages
;;------------------------------------------------------------------------------

(use-package helm
  :ensure t
  :init
  (helm-mode 1)
  :config
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action))

;; Colemak vimish keybinds
(use-package evil
  :ensure t
  :ensure helm
  :ensure sly
  :init
  (evil-mode 1)
  :config
  (defun define-general-key (key action)
    (define-key evil-normal-state-map key action)
    (define-key evil-visual-state-map key action)
    (define-key evil-emacs-state-map key action)
    (define-key evil-motion-state-map key action))

  (define-general-key "n" 'evil-next-line)
  (define-general-key "e" 'evil-previous-line)
  (define-general-key "h" 'evil-backward-char)
  (define-general-key "i" 'evil-forward-char)

  (define-general-key (kbd "C-i") 'evil-forward-word-begin)
  (define-general-key (kbd "C-h") 'evil-backward-word-begin)
  (define-general-key (kbd "C-n") 'evil-scroll-page-down)
  (define-general-key (kbd "C-e") 'evil-scroll-page-up)
  (define-general-key "I" 'evil-end-of-line)
  (define-general-key "H" 'back-to-indentation)

  (define-general-key "N" 'evil-goto-line)
  (define-general-key "E" 'evil-goto-first-line)

  (define-general-key "s" 'evil-insert-state)
  (define-general-key "t" 'evil-delete)
  (define-general-key ";" 'helm-M-x)
  (define-key evil-insert-state-map (kbd "TAB") 'sly-complete-symbol))

(use-package evil-leader
  :ensure t
  :ensure helm
  :ensure smartparens
  :init
  (global-evil-leader-mode)
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    ;; Window bindings
    "wh"  'evil-window-left
    "wn"  'evil-window-down
    "we"  'evil-window-up
    "wi"  'evil-window-right
    ;; Buffer bindings
    "bb"  'helm-buffers-list
    "bn"  'next-buffer
    "bp"  'previous-buffer'
    ;; File bindings
    "ff"  'helm-find-files
    "fs"  'save-buffer
    "fq"  'kill-buffer
    ;; Git bindings
    "gg"  'magit-status)
  (evil-leader/set-key-for-mode 'lisp-mode
    ;; Sly bindings
    "mef" 'sly-eval-defun
    "mer" 'sly-eval-region
    "meb" 'sly-eval-buffer
    "mcf" 'sly-compile-defun
    "mcr" 'sly-compile-region
    "msi" 'sly
    "msc" 'sly-connect)
  (evil-leader/set-key-for-mode 'sly-db-mode
    "mda" 'sly-db-abort
    "mdc" 'sly-db-continue))

  (use-package solarized-theme
    :ensure t
    :init
    (load-theme 'solarized-dark t))

(use-package powerline
  :init
  (powerline-default-theme))

;; Highlight whitespace, tabs, and lines longer than 80 characters
(use-package whitespace
  :init
  (global-whitespace-mode t)
  :config
  (setq whitespace-line-column 80)
  (setq whitespace-style '(face tabs lines-tail trailing)))

;; Spell checking for text mode
(use-package flyspell
  :ensure t
  :config
  (add-hook 'text-mode-hook 'flyspell-mode))

;; Slime
(use-package sly-autoloads
  :ensure sly
  :config
  (setq inferior-lisp-program "sbcl")
  (add-hook 'sly-connected-hook (lambda ()
                                  (previous-buffer)
                                  (pop-to-buffer "*sly-mrepl for sbcl*"))))

;;
;; Paren highlighting, indentation, and navigation

(show-paren-mode t)

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package autopair
  :ensure t)

(use-package highlight-parentheses
  :ensure t)

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

;;
;; Misc.

(use-package magit
  :ensure t)
