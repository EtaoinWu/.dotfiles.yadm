;; -*- coding: utf-8; lexical-binding: t -*-

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable bars
(menu-bar-mode -1)
(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

;; Highlight current line.
(global-hl-line-mode t)
(line-number-mode t)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load-file custom-file)

;; Setup Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/") t)
(setq package-native-compile t)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (message "refreshing contents")
  (unless package-archive-contents (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)

;; Setup some defaults
(setq gc-cons-threshold 100000000)
(setq max-specpdl-size 5000)

;; Some command
(bind-key* "C-;" #'execute-extended-command)
(bind-key* "C-c ;" #'execute-extended-command)
(bind-key* "C-c 4" #'execute-extended-command) ;; for a purely left-handed combo
(bind-key* "C-c C-;" #'execute-extended-command-for-buffer)

;; Package dependencies
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

(use-package try)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fix Emacs's Defaults                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq
 ;; No need to see GNU agitprop.
 inhibit-startup-screen t
 ;; No need to remind me what a scratch buffer is.
 initial-scratch-message nil
 ;; Double-spaces after periods is morally wrong.
 sentence-end-double-space nil
 ;; Never ding at me, ever.
 ring-bell-function 'ignore
 ;; Save existing clipboard text into the kill ring before replacing it.
 save-interprogram-paste-before-kill t
 ;; Prompts should go in the minibuffer, not in a GUI.
 use-dialog-box nil
 ;; Fix undo in commands affecting the mark.
 mark-even-if-inactive nil
 ;; Let C-k delete the whole line.
 kill-whole-line t
 ;; search should be case-sensitive by default
 case-fold-search nil
 ;; accept 'y' or 'n' instead of yes/no
 ;; the documentation advises against setting this variable
 ;; the documentation can get bent imo
 use-short-answers t
 ;; my source directory
 default-directory "~/Documents/"
 ;; eke out a little more scrolling performance
 fast-but-imprecise-scrolling t
 ;; prefer newer elisp files
 load-prefer-newer t
 ;; when I say to quit, I mean quit
 ; confirm-kill-processes nil
 ;; if native-comp is having trouble, there's not very much I can do
 ; native-comp-async-report-warnings-errors 'silent
 ;; unicode ellipses are better
 truncate-string-ellipsis "…"
 ;; I want to close these fast, so switch to it so I can just hit 'q'
 help-window-select t
 ;; this certainly can't hurt anything
 delete-by-moving-to-trash t
 ;; keep the point in the same place while scrolling
 scroll-preserve-screen-position t
 ;; more info in completions
 completions-detailed t
 ;; highlight error messages more aggressively
 next-error-message-highlight t
 ;; don't let the minibuffer muck up my window tiling
 read-minibuffer-restore-windows t
 ;; scope save prompts to individual projects
 save-some-buffers-default-predicate 'save-some-buffers-root
 ;; don't keep duplicate entries in kill ring
 kill-do-not-save-duplicates t
)

;; Never mix tabs and spaces. Never use tabs, period.
;; We need the setq-default here because this becomes
;; a buffer-local variable when set.
(setq-default indent-tabs-mode nil)

;; UTF-8 should always, *always* be the default.
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

;; Modernize behavior
(delete-selection-mode t)
(global-display-line-numbers-mode t)
(column-number-mode)
(savehist-mode)

;; Emacs 27 comes with fast current-line highlight functionality,
;; but it can produce some visual feedback in vterm buffers, so
;; we only activate it in programming or text modes.
(require 'hl-line)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)

;; Don't make all the noisy temp files
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

;; Fart the actively hostile default keybindings
(defun pt/unbind-bad-keybindings ()
  "Remove unhelpful keybindings."
  (-map (lambda (x) (unbind-key x)) '("C-x C-f" ;; find-file-read-only
                                      "C-x C-d" ;; list-directory
                                      "C-z" ;; suspend-frame
                                      "C-x C-z" ;; again
                                      "<mouse-2>" ;; pasting with mouse-wheel click
                                      "<C-wheel-down>" ;; text scale adjust
                                      "<C-wheel-up>" ;; ditto
                                      "s-n" ;; make-frame
                                      "s-t" ;; ns-popup-font-panel
                                      "s-p" ;; ns-print-buffer
                                      "C-x C-q" ;; read-only-mode
                                      )))
;; The next two lines simulates micro
(bind-key "C-s" #'save-buffer)
(bind-key "C-q" #'save-buffers-kill-terminal)
(bind-key "C-o" #'find-file)

;; These libraries are helpful to have around when writing little bits of elisp,
;; like the above. You can’t possibly force me to remember the difference between
;; the mapcar, mapc, mapcan, mapconcat, the cl- versions of some of the aforementioned,
;; and seq-map. I refuse. shut-up is good for noisy packages.
(use-package s)
(use-package dash :config (pt/unbind-bad-keybindings))
; (use-package shut-up)

;; Searching should be done with isearch, for UI purposes.
(bind-key "C-c f" #'isearch-forward-symbol)
(bind-key "C-f" #'isearch-forward-regexp)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)

;; Some whitespace defaults
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq require-final-newline t)

;; Remove GNU news
(defalias 'view-emacs-news 'ignore)
(defalias 'describe-gnu-project 'ignore)
(defalias 'describe-copying 'ignore)

;; Undo
(use-package vundo
  :diminish
  :bind* (("C-c z" . vundo))
  :custom (vundo-glyph-alist vundo-unicode-symbols))
(bind-key* "C-z" #'undo)

;; By default, Emacs wraps long lines, inserting a little icon to
;; indicate this. I find this a bit naff. What we can do to mimic
;; more modern behavior is to allow line truncation by default, but
;; also allow touchpad-style scrolling of the document.
(setq mouse-wheel-tilt-scroll t
      mouse-wheel-flip-direction t)
(setq-default truncate-lines t)

;; By default, Emacs ships with a nice completion system based on
;; buffer contents, but inexplicably cripples its functionality by
;; setting this completion system to ignore case in inserted results.
;; Absolutely remarkable choice of defaults.
(use-package dabbrev
  :bind* (("C-_" . #'dabbrev-completion))
  :custom
  (dabbrev-check-all-buffers t)
  (dabbrev-case-replace nil))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visuals                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Allow colors by default in its compilation buffer
(use-package fancy-compilation :config (fancy-compilation-mode))

;; Good looking fonts
(set-face-attribute 'default nil :font "Menlo-13")
(set-face-attribute 'variable-pitch nil :font "SF Mono-12")

;; Good looking icons
(let ((installed (package-installed-p 'all-the-icons)))
  (use-package all-the-icons)
  (unless installed (all-the-icons-install-fonts)))

(use-package all-the-icons-dired
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

;; Theme
(use-package spacemacs-theme
  :config
  ;; Do not use a different background color for comments.
  (setq spacemacs-theme-comment-bg nil)

  ;; Comments should appear in italics.
  (setq spacemacs-theme-comment-italic t)

  ;; Use the `spacemacs-dark` theme.
  (load-theme 'spacemacs-dark))

;; Editing plugins

;; CompAny
(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

;; Recent buffers in a new Emacs session
(use-package recentf
  :config
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 1000
        recentf-save-file (concat user-emacs-directory ".recentf"))
  (recentf-mode t)
  :diminish nil)

;; Display possible completions at all places
(use-package ido-completing-read+
  :ensure t
  :config
  ;; This enables ido in all contexts where it could be useful, not just
  ;; for selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  ;; Includes buffer names of recently opened files, even if they're not open now.
  (setq ido-use-virtual-buffers t)
  :diminish nil)

;; Enhance M-x to allow easier execution of commands
(use-package smex
  :ensure t
  ;; Using counsel-M-x for now. Remove this permanently if counsel-M-x works better.
  :disabled t
  :config
  (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  (smex-initialize)
  :bind ("M-x" . smex))

;; Git integration for Emacs
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Better handling of paranthesis when writing Lisps.
;; (use-package paredit
;;   :ensure t
;;   :init
;;   (add-hook 'clojure-mode-hook #'enable-paredit-mode)
;;   (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
;;   (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
;;   (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;;   (add-hook 'ielm-mode-hook #'enable-paredit-mode)
;;   (add-hook 'lisp-mode-hook #'enable-paredit-mode)
;;   (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;;   (add-hook 'scheme-mode-hook #'enable-paredit-mode)
;;   :config
;;   (show-paren-mode t)
;;   :bind (("M-[" . paredit-wrap-square)
;;          ("M-{" . paredit-wrap-curly))
;;   :diminish nil)
