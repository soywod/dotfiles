(scroll-bar-mode -1)
(tool-bar-mode -1)   
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda-list)
(global-set-key (kbd "C-c t") 'org-todo-list)

(setq disabled-command-function nil)
(setq inhibit-startup-screen t)
(setq visible-bell t)

;; Backup

(setq version-control t     ;; Use version numbers for backups.
      kept-new-versions 10  ;; Number of newest versions to keep.
      kept-old-versions 0   ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t)  ;; Copy all files, don't rename them.
(setq vc-make-backup-files t)
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

(setq calendar-week-start-day 1)

(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")
(setq mail-user-agent 'gnus-user-agent)

(setq gnus-select-method
      '(nnimap "posteo"
	       (nnimap-address "posteo.de")
	       (nnimap-server-port 143)
	       (nnimap-stream starttls)
	       (nnimap-authinfo-file "~/.authinfo.gpg")))
	       
(setq gnus-message-archive-group "nnimap+posteo:Sent")
(setq gnus-gcc-mark-as-read t)
(setq nnmail-expiry-target "nnimap+posteo:Trash")
(setq nnmail-expiry-wait 'immediate)
(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "posteo.de")
(setq smtpmail-smtp-service 587)
(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "On %d/%m/%Y %H:%M, %N wrote:")

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-diagnostics-provider :flycheck)
  (setq lsp-signature-auto-activate t))
(with-eval-after-load 'lsp-mode
  (setq lsp-modeline-diagnostics-scope :workspace))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package rust-mode
  :hook (rust-mode . lsp-deferred)
  ;; :bind
  ;; ("C-c g" . rust-run)
  ;; ("C-c t" . rust-test)
  ;; ("C-c b" . cargo-process-build)
  :init
  (which-function-mode 1)
  :config
  (setq rust-format-on-save t))

(use-package smartparens
  :bind ("C-c s s" . sp-splice-sexp)
  :bind ("C-c s r" . sp-rewrap-sexp))

(use-package bbdb
  :init
  (bbdb-initialize 'gnus 'message)
  (bbdb-mua-auto-update-init 'gnus 'message)
  :config
  (setq bbdb-file "~/documents/contacts/bbdb")
  (setq bbdb-mua-auto-update-p 'query))

(use-package org
  :config
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
	  ("a" "Agenda" entry (file "~/documents/org/agenda.org") "* TODO %i%? \n %U"))))
  ;; (setq-default org-display-custom-times t)
  ;; (setq org-time-stamp-custom-formats '("<%d/%m/%Y>" . "<%d/%m/%Y %H:%M>")))

(use-package magit)

(use-package ledger-mode)
