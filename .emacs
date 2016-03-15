;;------------------------------------------------------------------------------
;; General Configuration
;;------------------------------------------------------------------------------

(setq backup-by-copying t
      backup-directory-alist
      '(("." . "~/.saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
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
  :ensure helm-projectile
  :init
  (helm-mode 1)
  :config
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action))

;; Colemak vimish keybinds
(use-package evil
  :ensure t
  :ensure helm
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
  (define-general-key "!" 'shell-command)

  (define-general-key (kbd "<f5>") 'compile))

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
    "bp"  'previous-buffer
    "bq"  'kill-this-buffer
    ;; File bindings
    "ff"  'helm-find-files
    "fs"  'save-buffer
    ;; Misc bindings
    "gg"  'magit-status
    "ss"  'ansi-term)
  (evil-leader/set-key-for-mode 'lisp-mode
    ;; Slime bindings
    "mef" 'slime-eval-defun
    "mer" 'slime-eval-region
    "meb" 'slime-eval-buffer

    "mcb" 'slime-comgile-buffer
    "mcf" 'slime-compile-defun
    "mcr" 'slime-compile-region

    "msi" 'slime
    "msc" 'slime-connect))

(use-package solarized-theme
  :ensure t
  :init
  (load-theme 'solarized-dark t))

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

;;
;; Lisp stuff

(show-paren-mode t)
(add-hook 'lisp-mode-hook 'pretty-lambda-mode)

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-fancy slime-banner slime-asdf))
  (slime-setup))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

;;
;; C Stuff

(setq c-toggle-auto-newline 1)
(setq-default c-basic-offset 4)

(use-package semantic
  :init
  (use-package semantic/bovine/gcc)
  :config
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
  (semantic-mode 1)
  (global-ede-mode t)
  (ede-enable-generic-projects))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'c-mode-hook #'flycheck-mode))

(use-package company
  :ensure t
  :config
  (add-hook 'c-mode-hook #'company-mode))

;;
;; Misc.

(use-package magit
  :ensure t)
