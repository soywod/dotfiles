(scroll-bar-mode -1)
(tool-bar-mode -1)   
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda-list)

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

(setq calendar-week-start-day 1
      calendar-day-name-array ["Dimanche" "Lundi" "Mardi" "Mercredi" 
                               "Jeudi" "Vendredi" "Samedi"]
      calendar-month-name-array ["Janvier" "Février" "Mars" "Avril" "Mai"
                                 "Juin" "Juillet" "Août" "Septembre" 
                                 "Octobre" "Novembre" "Décembre"])

(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")
(setq mail-user-agent 'gnus-user-agent)

(setq gnus-select-method
      '(nnimap "posteo"
	       (nnimap-address "posteo.de")
	       (nnimap-server-port 993)
	       (nnimap-stream ssl)
	       (nnimap-authinfo-file "~/.authinfo.gpg")))
	       
(setq gnus-message-archive-group "nnimap+posteo:Sent")
(setq gnus-gcc-mark-as-read t)
(setq nnmail-expiry-target "nnimap+posteo:Trash")
(setq nnmail-expiry-wait 'immediate)
(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "posteo.de")
(setq message-citation-line-function 'message-insert-formatted-citation-line)
(setq message-citation-line-format "On %d/%m/%Y %H:%M, %N wrote:")

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("org"   . "https://orgmode.org/elpa/")
        ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package smartparens
  :bind ("C-c s d" . sp-splice-sexp)
  :bind ("C-c s r" . sp-rewrap-sexp))

(use-package flycheck
  :config 
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

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

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map ("<tab>" . company-select-next))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(use-package org
  :config
  (setq org-agenda-files
	'("~/.local/share/org/inbox.org"
	  "~/.local/share/org/tasks.org"
  	  "~/.local/share/org/agenda.org"
	  "~/.local/share/org/habits.org"))
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-targets
	'(("~/.local/share/org/tasks.org" :maxlevel . 3)
	  ("~/.local/share/org/someday.org" :level . 1)
	  ("~/.local/share/org/agenda.org" :level . 1)
  	  ("~/.local/share/org/habits.org" :level . 1)))
  (setq org-todo-keywords
	'((sequence "TODO(t)" "PENDING(p)" "|" "CANCELLED(c)" "DONE(d)")))
  (setq org-todo-keyword-faces
	'(("TODO" . (:foreground "#c678dd" :weight bold))
	  ("PENDING" . (:background "#3f444a" :foreground "#ff6c6b" :weight bold))))
  (setq org-capture-templates
	'(("i" "Inbox" entry (file "~/.local/share/org/inbox.org") "* %i%?")
	  ("a" "Agenda" entry (file "~/.local/share/org/agenda.org") "* %i%? \n %U")))
  (setq-default org-display-custom-times t)
  (setq org-time-stamp-custom-formats '("<%d/%m/%Y>" . "<%d/%m/%Y, %H:%M>")))

(use-package magit)

(use-package ledger-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(telega ledger-mode magit doom-themes company rust-mode typescript-mode lsp-mode flycheck smartparens expand-region use-package))
 '(smtpmail-smtp-server "posteo.de")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
