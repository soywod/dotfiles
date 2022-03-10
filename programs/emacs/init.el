(scroll-bar-mode -1)
(tool-bar-mode -1)   
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq disabled-command-function nil)
(setq inhibit-startup-screen t)
(setq visible-bell t)
(setq completion-styles '(flex))
(setq flycheck-check-syntax-automatically '(mode-enabled save))
(defalias 'yes-or-no-p 'y-or-n-p)

;; Backup

(setq vc-make-backup-files nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")
(setq calendar-week-start-day 1)

(defun default-web-indent-mode ()
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package doom-themes
  :init (load-theme 'doom-one t)
  :init (doom-themes-org-config))

(use-package direnv
  :config (direnv-mode))

(use-package ledger-mode
  :mode "\\.ldg\\'")

(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :init (setq lsp-signature-auto-activate nil)
  :init (setq lsp-enable-on-type-formatting nil)
  :init (setq lsp-completion-provider :none)
  :init (setq lsp-eldoc-enable-hover nil)
  :init (setq lsp-rust-analyzer-proc-macro-enable t)
  :config (lsp-enable-which-key-integration t)
  :hook (lsp-mode . electric-pair-mode))

(use-package flycheck
  :delight)

(use-package prettier-js
  :delight)

(use-package web-mode
  :delight
  :mode "\\.[jt]sx?\\'"
  :hook (web-mode . default-web-indent-mode)
  :hook (web-mode . prettier-js-mode)
  :hook (web-mode . emmet-mode)
  :hook (web-mode . lsp-deferred))

(use-package scss-mode
  :delight
  :hook (scss-mode . default-web-indent-mode)
  :hook (scss-mode . prettier-js-mode)
  :hook (scss-mode . emmet-mode)
  :hook (scss-mode . lsp-deferred))

(use-package emmet-mode
  :delight
  :config (setq emmet-indent-after-insert nil)
  :config (add-to-list 'emmet-jsx-major-modes 'web-mode)
  :bind (:map emmet-mode-keymap ("C-j" . nil))
  :bind (:map emmet-mode-keymap ("C-<return>" . emmet-expand-line))
  :bind (:map emmet-mode-keymap ("M-RET" . emmet-expand-line)))

(use-package nix-mode
  :delight
  :mode ("\\.nix\\'" . nix-mode)
  :hook (nix-mode . (lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)))
  :hook (nix-mode . lsp-deferred))

(use-package rust-mode
  :delight
  :init (setq rust-format-on-save t)
  :config (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)
  :hook (rust-mode . lsp-deferred))

(use-package yasnippet
  :delight yas-minor-mode
  :config (setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets"))
  :hook (lsp-mode . yas-minor-mode)
  :hook (yas-minor-mode . yas-reload-all))

(use-package eldoc
  :delight)

(use-package smartparens
  :delight
  :bind ("C-c s s" . sp-splice-sexp)
  :bind ("C-c s r" . sp-rewrap-sexp))

(use-package bbdb
  :init (bbdb-initialize 'gnus 'message)
  :init (bbdb-mua-auto-update-init 'gnus 'message)
  :init (setq bbdb-file "~/documents/contacts/bbdb")
  :init (setq bbdb-mua-auto-update-p 'create))

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
	  ("a" "Agenda" entry (file "~/documents/org/agenda.org") "* TODO %i%?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \".\"))")))
  (setq org-agenda-custom-commands
	'(("T" "Active tasks" tags-todo "+LEVEL=1+CATEGORY=\"tasks\"")
	  ("A" "Today's agenda" agenda "" ((org-agenda-span 'day)
					   (org-agenda-category-filter-preset '("-habits"))))
	  ("W" "Week's agenda" agenda "" ((org-agenda-span 'week)
					   (org-agenda-category-filter-preset '("-habits"))))
	  ("M" "Month's agenda" agenda "" ((org-agenda-span 'month)
					   (org-agenda-category-filter-preset '("-habits")))))))

(use-package magit)

(use-package ledger-mode)

(use-package helm
  :delight
  :init (helm-mode)
  :bind (:map helm-find-files-map ("TAB" . helm-ff-RET))
  :bind ("M-x" . helm-M-x)
  :bind ("C-x C-f" . helm-find-files))

(use-package helm-lsp
  :bind (:map lsp-mode-map ("C-c l a a" . helm-lsp-code-actions)))

(use-package helm-projectile
  :init (helm-projectile-on))

(use-package abbrev
  :delight)

(use-package projectile
  :init (projectile-global-mode)
  :config (setq projectile-enable-caching nil)
  :config (setq projectile-project-search-path (cddr (directory-files "~/code" t)))
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package which-key
  :delight
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.5))

(use-package himalaya
  :if (file-exists-p "~/code/himalaya-emacs")
  :load-path "~/code/himalaya-emacs")

(defun custom/capitalize-first-char (&optional string)
  "Capitalize only the first character of the input STRING."
  (when (and string (> (length string) 0))
    (let ((first-char (substring string nil 1))
          (rest-str   (substring string 1)))
      (concat (capitalize first-char) rest-str))))
