;; Global config

(scroll-bar-mode -1)
(tool-bar-mode -1)   
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)
(electric-pair-mode)
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

(require 'autorevert)
(delight 'auto-revert-mode nil 'autorevert)

(require 'abbrev)
(delight 'abbrev-mode nil 'abbrev)

(require 'eldoc)
(delight 'eldoc-mode nil 'eldoc)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

(require 'which-key)
(setq which-key-idle-delay 0.5)
(which-key-mode)
(delight 'which-key-mode nil 'which-key)

(require 'projectile)
(setq projectile-enable-caching nil)
(setq projectile-project-search-path (cddr (directory-files "~/code" t)))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-global-mode)
(delight 'projectile-mode (format " Proj[%s]" (projectile-project-name)) 'projectile)

(require 'helm)
(require 'helm-projectile)
(require 'helm-lsp)
(helm-mode)
(helm-projectile-on)
(define-key helm-find-files-map (kbd "<tab>") 'helm-ff-RET)
(define-key helm-projectile-find-file-map (kbd "<tab>") 'helm-ff-RET)
(define-key helm-generic-files-map (kbd "<tab>") 'helm-ff-RET)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(delight 'helm-mode nil)

(require 'smartparens)
(global-set-key (kbd "C-c s s") 'sp-splice-sexp)
(global-set-key (kbd "C-c s r") 'sp-rewrap-sexp)
(global-set-key (kbd "C-c s k") 'sp-kill-hybrid-sexp)
(delight 'smartparens-mode nil 'smartparens)

(require 'magit)
(delight 'magit-mode nil 'magit)

(require 'ledger-mode)

(require 'flymake)
(setq flymake-start-on-flymake-mode t)
(setq flymake-start-on-save-buffer t)
(setq flymake-no-changes-timeout nil)
(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)

(require 'company)
(define-key company-active-map (kbd "<tab>") nil) ; make snippets expand properly
(delight 'company-mode nil 'company)

(require 'eglot)
(setq eglot-extend-to-xref t)
(setq eglot-stay-out-of '(eldoc))
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
(define-key eglot-mode-map (kbd "C-c t") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "M-.") 'xref-find-definitions)

(require 'rust-mode)
(add-to-list 'auto-mode-alist '("\\.rust\\'" . rust-mode))
(add-hook 'rust-mode-hook 'soywod/format-on-save-hook)
(add-hook 'rust-mode-hook 'eglot-ensure)

(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-hook 'nix-mode-hook 'soywod/format-on-save-hook)
(add-hook 'nix-mode-hook 'eglot-ensure)

(require 'web-mode)
(setq lsp-typescript-format-enable nil)
(setq lsp-javascript-format-enable nil)
(add-to-list 'auto-mode-alist '("\\.[jt]sx?\\'" . web-mode))
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'eglot-ensure)

;; scss-mode
(add-hook 'scss-mode-hook 'soywod/default-web-indent-mode)
(add-hook 'scss-mode-hook 'prettier-js-mode)
(add-hook 'scss-mode-hook 'eglot-ensure)

(require 'yasnippet)
(setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets"))
(add-hook 'yas-minor-mode 'yas-reload-all)
(delight 'yas-minor-mode nil 'yasnippet)

(require 'direnv)
(direnv-mode)

(require 'ledger-mode)
(add-to-list 'auto-mode-alist '("\\.ldg\\'" . ledger-mode))

(require 'prettier-js)

(require 'ox-latex)
(add-to-list 'org-latex-classes '("letter" "\\documentclass{frletter}"))

(require 'bbdb)
(setq bbdb-file "~/documents/contacts/bbdb")
(setq bbdb-mua-auto-update-p 'query)
(bbdb-initialize 'message)
(bbdb-mua-auto-update-init 'gnus 'message)

(require 'org)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files
      '("~/documents/org/inbox.org"
	"~/documents/org/tasks.org"
  	"~/documents/org/agenda.org"
	"~/documents/org/habits.org"))
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets
      '(("~/documents/org/tasks.org" :maxlevel . 3)
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
	("A" "Today's agenda" agenda "" ((org-agenda-span 'day)
					 (org-agenda-category-filter-preset '("-habits"))))
	("W" "Week's agenda" agenda "" ((org-agenda-span 'week)
					(org-agenda-category-filter-preset '("-habits"))))
	("M" "Month's agenda" agenda "" ((org-agenda-span 'month)
					 (org-agenda-category-filter-preset '("-habits"))))))
