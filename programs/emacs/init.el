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
(setq completion-ignore-case t)
(setq vc-make-backup-files nil) ; disable backup files on version control
(setq make-backup-files nil) ; disable backup files
(setq auto-save-default nil) ; disable auto save
(setq create-lockfiles nil) ; disable lock files
(setq calendar-week-start-day 1) ; adjust week start day
(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")
(setq split-width-threshold 0)

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
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 2)
  (setq-local web-mode-smart-quotes nil)
  (setq-local web-mode-markup-indent-offset 2)
  (setq-local web-mode-css-indent-offset 2)
  (setq-local web-mode-code-indent-offset 2))

(defun soywod/eglot-ensure ()
  (eglot-ensure)
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider)))

(defun soywod/eglot-ensure-without-formatting ()
  (eglot-ensure)
  (setq eglot-ignored-server-capabilities
	'(:documentFormattingProvider
	  :documentRangeFormattingProvider
	  :documentOnTypeFormattingProvider)))

(defun soywod/org-clock-toggle ()
  (interactive)
  (if org-clock-current-task (org-clock-out) (org-clock-in-last)))

;; Theme

(require 'doom-themes)
(load-theme 'doom-one-light t)
(doom-themes-org-config)

;; Packages

(require 'delight)

;; autorevert
(delight 'auto-revert-mode nil 'autorevert)

;; abbrev
(delight 'abbrev-mode nil 'abbrev)

;; eldoc
(setq eldoc-echo-area-use-multiline-p nil)
(delight 'eldoc-mode nil 'eldoc)

;; fido
(add-hook 'after-init-hook 'fido-vertical-mode)

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

(require 'eglot)
(setq eglot-extend-to-xref t)
(define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c t") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
(define-key eglot-mode-map (kbd "C-c h") 'eldoc)
(define-key eglot-mode-map (kbd "M-.") 'xref-find-definitions)

(require 'prettier-js)
(delight 'prettier-js-mode nil 'prettier-js)

(require 'web-mode)
(define-derived-mode tsx-mode web-mode "TypeScript/React")
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-mode))
(cl-defmethod project-root ((project (head eglot-project))) (cdr project))
(defun my-project-try-tsconfig-json (dir)
  (when-let* ((found (locate-dominating-file dir "tsconfig.json")))
    (cons 'eglot-project found)))
(add-to-list 'eglot-server-programs '(tsx-mode . ("typescript-language-server" "--stdio")))
(add-hook 'project-find-functions
          'my-project-try-tsconfig-json nil nil)
(add-hook 'tsx-mode-hook 'soywod/eglot-ensure-without-formatting)
(add-hook 'tsx-mode-hook 'soywod/default-web-indent-mode)
(add-hook 'tsx-mode-hook 'prettier-js-mode)

(require 'typescript-mode)
(setq typescript-indent-level 2)
(setq typescript-auto-indent-flag nil)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
(add-hook 'typescript-mode-hook 'soywod/eglot-ensure-without-formatting)
(add-hook 'typescript-mode-hook 'prettier-js-mode)

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

(require 'vimrc-mode)
(add-hook 'vimrc-mode-hook 'soywod/eglot-ensure)

(require 'lua-mode)
(add-hook 'lua-mode-hook 'soywod/eglot-ensure)

(require 'yasnippet)
(setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets"))
(add-hook 'after-init-hook 'yas-global-mode)
(add-hook 'yas-global-mode-hook 'yas-reload-all)
(delight 'yas-minor-mode nil 'yasnippet)

(require 'direnv)
(direnv-mode)

(require 'ox-latex)
(add-to-list 'org-latex-classes '("letter" "\\documentclass{frletter}"))

(require 'ox-md)

(require 'bbdb)
(setq bbdb-file "~/documents/contacts")
(setq bbdb-mua-auto-update-p 'query)
(bbdb-initialize 'message)
(bbdb-mua-auto-update-init 'gnus 'message)

(require 'paren)
(setq show-paren-delay 0)
(add-hook 'after-init-hook 'show-paren-mode)
(set-face-attribute 'show-paren-match nil :weight 'extra-bold :slant 'normal)

(require 'org)
(require 'org-clock)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c SPC") 'soywod/org-clock-toggle)
(setq org-effort-durations
      `(("min" . 1)
	("h" . 60)
	("d" . ,(* 60 7))
	("j" . ,(* 60 7))
	("w" . ,(* 60 7 5))
	("s" . ,(* 60 7 5))
	("m" . ,(* 60 7 5 4))
	("y" . ,(* 60 7 5 4 12))
	("a" . ,(* 60 7 5 4 12))))
(setq org-startup-folded t)
(setq org-agenda-files '("~/documents/gtd/agenda.org"))
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '(("~/documents/gtd/tasks.org" :maxlevel . 3)
			   ("~/documents/gtd/someday.org" :level . 1)
			   ("~/documents/gtd/agenda.org" :level . 1)
  			   ("~/documents/gtd/habits.org" :level . 1)))
(setq org-todo-keywords
      '((sequence "TODO(t)" "PENDING(p)" "|" "CANCELLED(c)" "DONE(d)")))
;; (setq org-todo-keyword-faces
;;       '(("TODO" . (:foreground "#c678dd" :weight bold))
;; 	("PENDING" . (:background "#3f444a" :foreground "#ff6c6b" :weight bold))))
(setq org-capture-templates
      '(("i" "Inbox" entry (file "~/documents/gtd/inbox.org") "* TODO %i%?")
	("a" "Agenda" entry (file "~/documents/gtd/agenda.org") "* TODO %i%?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \".\"))")))
(setq org-agenda-custom-commands
      '(("T" "Active tasks" tags-todo "+LEVEL=1+CATEGORY=\"tasks\"")
	("h" "Today's habits" tags-todo "+DEADLINE<=\"<today>\"" ((org-agenda-files '("~/documents/gtd/habits.org"))))
	("A" "Today's agenda" agenda "" ((org-agenda-span 'day)))
	("W" "Week's agenda" agenda "" ((org-agenda-span 'week)))
	("M" "Month's agenda" agenda "" ((org-agenda-span 'month)))))

(defun soywod/org-clock-get-table-data (file start end)
  (let* ((start (format-time-string (org-time-stamp-format t t) start))
	 (end (format-time-string (org-time-stamp-format t t) end))
	 (params (list :maxlevel 0 :tstart start :tend end)))
    (org-clock-get-table-data file params)))

;; (defun soywod/to-duration-str (mins)
;;   "Transforms integer minutes into a minimalistic human-readable
;; string duration."
;;   (let ((durations '()))
;;     (dolist (unit (reverse org-duration-units))
;;       (let* ((unit-symbol (car unit))
;; 	     (unit (cdr unit)))
;; 	(when (>= mins unit)
;; 	  (push (format "%d%s%s" (/ mins unit) "" unit-symbol) durations)
;; 	  (setq mins (mod mins unit)))))
;;     (string-join (reverse durations) " ")))

(defun round-price (price)
  (/ (fround (* 100 price)) 100))

(setq calc-float-format '(fix 2))
(setq calc-point-char ",")
(setq calc-group-char " ")
(setq calc-group-digits t)

(defun org-dblock-write:invoice (params)
  (let* ((file (or (plist-get params :file) (buffer-file-name)))
         (rate (plist-get params :rate))
         (start (time-convert (org-matcher-time (plist-get params :tstart))))
         (end (time-convert (org-matcher-time (plist-get params :tend))))
	 (total-time 0)
	 (total-vat-excl 0)
	 (total-vat 0))
    (insert "|Jour"
	    "|Durée"
	    "|Montant\n"
	    "|-\n"
	    "|<l>"
	    "|<r>"
	    "|<r>\n")
    (while (time-less-p start end)
      (let* ((next-day (time-add start (* 60 60 24)))
	     (time (org-clock-sum start next-day))
	     (amount (round-price (/ (float (* time rate)) 60))))
	(unless (zerop time)
	  (setq total-time (+ total-time time))
	  (setq total-vat-excl (+ total-vat-excl amount))
	  (insert "|" (format-time-string "%a %d" start)
		  "|" (org-duration-from-minutes time '((special . h:mm)))
		  "|" (calc-eval (number-to-string amount))
		  "|\n"))
	(setq start next-day)))
    (org-table-align)
    (setq total-vat (round-price (* 0.2 total-vat-excl)))
    (insert "\n"
	    "|Total\n"
	    "|-\n"
	    "|<l>"
	    "|<r>\n"
	    "|Durée"
	    "|" (org-duration-from-minutes total-time '(("j" . true) (special . h:mm))) "\n"
	    "|HT"
	    "|" (calc-eval (number-to-string total-vat-excl)) "\n"
	    "|TVA 20%"
	    "|" (calc-eval (number-to-string total-vat)) "\n"
	    "|TTC"
	    "|" (calc-eval (number-to-string (+ total-vat-excl total-vat))) "\n")
    (org-table-align)))

;; Local packages

(add-to-list 'load-path "~/code/himalaya-emacs")
(require 'himalaya)
(setq himalaya-executable "/home/soywod/code/himalaya/target/debug/himalaya")
;; (setq himalaya-config-path "/home/soywod/.himalaya.config.toml")
;; (setq himalaya-default-folder "INBOX")

(add-to-list 'load-path "~/code/org-latex-invoice")
(require 'org-latex-invoice)

(add-to-list 'load-path "~/code/emacs-prisma-mode")
(require 'prisma-mode)
(add-to-list 'auto-mode-alist '("\\.prisma\\'" . prisma-mode))
(add-to-list 'eglot-server-programs '(prisma-mode . ("prisma-language-server" "--stdio")))
(add-hook 'prisma-mode-hook 'soywod/eglot-ensure)
