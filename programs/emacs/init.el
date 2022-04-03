;; Global config

(scroll-bar-mode -1)
(tool-bar-mode -1) 
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq disabled-command-function nil) ; activate all commands
(setq inhibit-startup-screen t) ; deactivate startup screen
(setq visible-bell t) ; activate visual bell
(setq completion-styles '(flex)) ; enable flex partial completion
(setq vc-make-backup-files nil) ; disable backup files on version control
(setq make-backup-files nil) ; disable backup files
(setq auto-save-default nil) ; disable auto save
(setq create-lockfiles nil) ; disable lock files
(setq calendar-week-start-day 1) ; adjust week start day
(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")

;; Custom functions

(defun soywod/format-on-save-hook ()
  (add-hook 'before-save-hook 'eglot-format nil 'local))

(defun soywod/capitalize-first-char (&optional string)
  "Capitalize only the first character of the input STRING."
  (when (and string (> (length string) 0))
    (let ((first-char (substring string nil 1))
          (rest-str (substring string 1)))
      (concat (capitalize first-char) rest-str))))

(defun soywod/default-web-indent-mode ()
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq web-mode-smart-quotes nil)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(defun soywod/eglot-ensure ()
  (eglot-ensure)
  (setq eglot-ignored-server-capabilities '()))

(defun soywod/eglot-ensure-without-formatting ()
  (eglot-ensure)
  (setq eglot-ignored-server-capabilities
	'(:documentFormattingProvider
	  :documentRangeFormattingProvider
	  :documentOnTypeFormattingProvider)))

;; Theme

(require 'doom-themes)
(load-theme 'doom-one t)
(doom-themes-org-config)

;; Local packages

(add-to-list 'load-path "~/code/himalaya-emacs")
(require 'himalaya)
(setq himalaya-executable "/home/soywod/code/himalaya/target/debug/himalaya")

(add-to-list 'load-path "~/code/org-latex-invoice")
(require 'org-latex-invoice)

;; Packages

(require 'delight)

;; autorevert
(delight 'auto-revert-mode nil 'autorevert)

;; abbrev
(delight 'abbrev-mode nil 'abbrev)

;; eldoc
(delight 'eldoc-mode nil 'eldoc)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

(require 'which-key)
(setq which-key-idle-delay 0.5)
(add-hook 'after-init-hook 'which-key-mode)
(delight 'which-key-mode nil 'which-key)

(require 'projectile)
(setq projectile-enable-caching nil)
(setq projectile-project-search-path (cddr (directory-files "~/code" t)))
(add-hook 'after-init-hook 'projectile-global-mode)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(delight 'projectile-mode (format " Proj[%s]" (projectile-project-name)) 'projectile)

(require 'flx)
(require 'ivy)
(setq ivy-use-virtual-buffers t)
(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
(add-hook 'after-init-hook 'ivy-mode)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(set-face-attribute 'ivy-current-match nil :weight 'bold :background "#2257a0" :foreground nil)
(set-face-attribute 'ivy-minibuffer-match-face-1 nil :weight 'bold :background nil :foreground "#51afef")
(set-face-attribute 'ivy-minibuffer-match-face-2 nil :weight 'bold :background nil :foreground "#51afef")
(set-face-attribute 'ivy-minibuffer-match-face-3 nil :weight 'bold :background nil :foreground "#51afef")
(set-face-attribute 'ivy-minibuffer-match-face-4 nil :weight 'bold :background nil :foreground "#51afef")
(set-face-attribute 'ivy-virtual nil :slant 'normal :background nil :foreground "#bbc2cf")
(delight 'ivy-mode nil 'ivy)

(require 'counsel)
(add-hook 'after-init-hook 'counsel-mode)
(delight 'counsel-mode nil 'counsel)

(require 'counsel-projectile)
(add-hook 'after-init-hook 'counsel-projectile-mode)

(require 'swiper)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-r") 'swiper-backward)
(set-face-attribute 'swiper-line-face nil :weight 'bold :background "#2257a0" :foreground nil)
(set-face-attribute 'swiper-match-face-1 nil :background nil :foreground nil)
(set-face-attribute 'swiper-match-face-2 nil :weight 'bold :background "#51afef" :foreground "#282c34")
(set-face-attribute 'swiper-match-face-3 nil :weight 'bold :background "#51afef" :foreground "#282c34")
(set-face-attribute 'swiper-match-face-4 nil :weight 'bold :background "#51afef" :foreground "#282c34")
(set-face-attribute 'swiper-background-match-face-1 nil :background nil :foreground nil)
(set-face-attribute 'swiper-background-match-face-2 nil :background "#51afef" :foreground "#282c34")
(set-face-attribute 'swiper-background-match-face-3 nil :background "#51afef" :foreground "#282c34")
(set-face-attribute 'swiper-background-match-face-4 nil :background "#51afef" :foreground "#282c34")

(require 'smartparens)
(global-set-key (kbd "C-c s s") 'sp-splice-sexp)
(global-set-key (kbd "C-c s r") 'sp-rewrap-sexp)
(global-set-key (kbd "C-c s k") 'sp-kill-hybrid-sexp)
(delight 'smartparens-mode nil 'smartparens)

(require 'magit)
(delight 'magit-mode nil 'magit)

;; elisp
(delight 'emacs-lisp-mode "ELisp" :major)

(require 'flymake)
(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)

;; elec-pair
(add-hook 'after-init-hook 'electric-pair-mode)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(define-key company-active-map (kbd "<tab>") nil) ; make yasnippets expand properly
(delight 'company-mode nil 'company)

(require 'eglot)
(setq eglot-extend-to-xref t)
(setq eglot-stay-out-of '(eldoc))
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c t") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
(define-key eglot-mode-map (kbd "M-.") 'xref-find-definitions)

(require 'web-mode)
(require 'prettier-js)
(delight 'prettier-js-mode nil 'prettier-js)

;; js-ts-mode
(define-derived-mode js-ts-mode web-mode "Js")
(add-to-list 'auto-mode-alist '("\\.[jt]sx?\\'" . js-ts-mode))
(add-to-list 'eglot-server-programs '(js-ts-mode . ("typescript-language-server" "--stdio")))
(add-hook 'js-ts-mode-hook 'soywod/default-web-indent-mode)
(add-hook 'js-ts-mode-hook 'soywod/eglot-ensure-without-formatting)
(add-hook 'js-ts-mode-hook 'prettier-js-mode)

;; scss-mode
(add-hook 'scss-mode-hook 'soywod/default-web-indent-mode)
(add-hook 'scss-mode-hook 'soywod/eglot-ensure-without-formatting)
(add-hook 'scss-mode-hook 'prettier-js-mode)

(require 'rust-mode)
(add-to-list 'auto-mode-alist '("\\.rust\\'" . rust-mode))
(add-hook 'rust-mode-hook 'soywod/format-on-save-hook)
(add-hook 'rust-mode-hook 'soywod/eglot-ensure)

(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-hook 'nix-mode-hook 'soywod/format-on-save-hook)
(add-hook 'nix-mode-hook 'soywod/eglot-ensure)

(require 'ledger-mode)
(add-to-list 'auto-mode-alist '("\\.ldg\\'" . ledger-mode))

(require 'yasnippet)
(setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets"))
(add-hook 'after-init-hook 'yas-global-mode)
(add-hook 'yas-global-mode-hook 'yas-reload-all)
(delight 'yas-minor-mode nil 'yasnippet)

(require 'direnv)
(direnv-mode)

(require 'ox-latex)
(add-to-list 'org-latex-classes '("letter" "\\documentclass{frletter}"))

(require 'bbdb)
(setq bbdb-file "~/documents/contacts/bbdb")
(setq bbdb-mua-auto-update-p 'query)
(bbdb-initialize 'message)
(bbdb-mua-auto-update-init 'gnus 'message)

(require 'paren)
(setq show-paren-delay 0)
(add-hook 'after-init-hook 'show-paren-mode)
(set-face-attribute 'show-paren-match nil :weight 'extra-bold :slant 'normal)

(require 'org)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-startup-folded t)
(setq org-agenda-files
      '("~/documents/org/inbox.org"
	"~/documents/org/tasks.org"
	"~/documents/org/agenda.org"))
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '(("~/documents/org/tasks.org" :maxlevel . 3)
			   ("~/documents/org/someday.org" :level . 1)
			   ("~/documents/org/agenda.org" :level . 1)
  			   ("~/documents/org/habits.org" :level . 1)))
(setq org-todo-keywords
      '((sequence "TODO(t)" "PENDING(p)" "|" "CANCELLED(c)" "DONE(d)")))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "#c678dd" :weight bold))
	("PENDING" . (:background "#3f444a" :foreground "#ff6c6b" :weight bold))))
(setq org-capture-templates
      '(("i" "Inbox" entry (file "~/documents/org/inbox.org") "* TODO %i%?")
	("a" "Agenda" entry (file "~/documents/org/agenda.org") "* TODO %i%?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \".\"))")))
(setq org-agenda-custom-commands
      '(("T" "Active tasks" tags-todo "+LEVEL=1+CATEGORY=\"tasks\"")
	("h" "Today's habits" tags-todo "+DEADLINE<=\"<today>\"" ((org-agenda-files '("~/documents/org/habits.org"))))
	("A" "Today's agenda" agenda "" ((org-agenda-span 'day)))
	("W" "Week's agenda" agenda "" ((org-agenda-span 'week)))
	("M" "Month's agenda" agenda "" ((org-agenda-span 'month)))))
