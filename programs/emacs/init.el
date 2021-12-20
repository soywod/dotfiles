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
(setq flycheck-check-syntax-automatically '(mode-enabled save))

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

(use-package lsp-mode
  :hook ((web-mode . lsp-deferred)
	 (nix-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-signature-auto-activate t)
  :config (lsp-enable-which-key-integration t))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.s?css\\'" . web-mode)
         ("\\.[jt]sx?\\'" . web-mode)))
  
(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))

(use-package rust-mode
  :hook (rust-mode . lsp-deferred)
  :config
  (setq rust-format-on-save t))

(use-package company
  :config (setq company-idle-delay 0.5)
  :bind (:map company-active-map ("<tab>" . company-select-next))
  :bind (:map company-active-map ("<backtab>" . company-select-previous)))

(use-package yasnippet
  :hook ((lsp-mode . yas-minor-mode)
	 (yas-minor-mode . yas-reload-all))
  :config
  (setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets")))

(use-package prettier-js
  :requires (add-node-modules-path)
  :after (web-mode)
  :hook ((web-mode . add-node-modules-path)
	 (web-mode . prettier-js-mode)))

(use-package smartparens
  :bind (("C-c s s" . sp-splice-sexp)
	 ("C-c s r" . sp-rewrap-sexp)))

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

(use-package magit)

(use-package ledger-mode)

(use-package ivy
  :init (ivy-mode)
  :bind ("C-s" . swiper)
  :bind (:map ivy-minibuffer-map ("<tab>" . ivy-next-line))
  :bind (:map ivy-switch-buffer-map ("<tab>" . ivy-next-line))
  :bind (:map ivy-reverse-i-search-map ("<tab>" . ivy-next-line))
  :bind (:map ivy-minibuffer-map ("<backtab>" . ivy-previous-line))
  :bind (:map ivy-switch-buffer-map ("<backtab>" . ivy-previous-line))
  :bind (:map ivy-reverse-i-search-map ("<backtab>" . ivy-previous-line)))

(use-package counsel
  :init (counsel-mode)  
  :config (setq ivy-initial-inputs-alist nil)
  :bind ("M-x" . 'counsel-M-x)
  :bind ("C-x b" . 'counsel-ibuffer)
  :bind ("C-x C-f" . 'counsel-find-file)
  :bind (:map minibuffer-local-map ("C-r" . 'counsel-minibuffer-history)))

(use-package projectile
  :init (projectile-mode)
  :config (setq projectile-project-search-path (cddr (directory-files "~/code" t)))
  :custom (projectile-completion-system 'ivy)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :after (counsel projectile)
  :init (counsel-projectile-mode))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.5))
