;; increase garbage collector threshold temporarily
;; <https://github.com/daviwil/emacs-from-scratch/blob/master/show-notes/Emacs-Scratch-12.org#tweaking-the-garbage-collector>
(setq gc-cons-threshold (* 50 1000 1000))

;; Global configuration

(defalias 'yes-or-no-p 'y-or-n-p)

(setq calendar-week-start-day 1)
(setq disabled-command-function nil)
(setq inhibit-startup-screen t)
(setq user-full-name "Clément DOUIN")
(setq user-mail-address	"clement.douin@posteo.net")
(setq split-width-threshold 0) ; always split vertical

;; Completion
(setq completion-ignore-case t)
(setq completion-styles '(flex))

;; Backup
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq vc-make-backup-files nil)

;; Calc
(setq calc-float-format '(fix 2))
(setq calc-group-char " ")
(setq calc-group-digits t)
(setq calc-point-char ",")

;; Scratch buffer
;; (setq initial-major-mode 'org-mode)
(setq initial-scratch-message nil)

;; Menus and tooltips
(menu-bar-mode -1)
(tooltip-mode -1)

;; use fido vertical mode
(add-hook 'after-init-hook 'fido-vertical-mode)

;; Packages

(use-package doom-themes
  :config
  (load-theme 'doom-one-light t)
  (doom-themes-org-config))

(use-package direnv
  :hook (after-init . direnv-mode))

(use-package magit
  :delight
  :defer t)

(use-package eglot
  :init
  (setq eglot-extend-to-xref t)
  :bind
  (:map eglot-mode-map
	("C-c h" . eldoc)
	("C-c o" . eglot-code-action-organize-imports)
	("C-c r" . eglot-rename)
	("C-c t" . eglot-code-actions)
	("M-." . xref-find-definitions)))

(use-package flymake
  :bind
  (:map flymake-mode-map
	("M-p" . flymake-goto-prev-error)
	("M-n" . flymake-goto-next-error)))

(use-package projectile
  :init
  (setq projectile-project-search-path (cddr (directory-files "~/code" t)))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package eldoc
  :delight
  :init
  (setq eldoc-echo-area-use-multiline-p nil))

(use-package rust-mode
  :mode ("\\.rust\\'" . rust-mode)
  :hook
  (rust-mode . soywod/eglot-ensure)
  (rust-mode . soywod/format-on-save-hook))

(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode)
  :hook
  (nix-mode . soywod/eglot-ensure)
  (nix-mode . soywod/format-on-save-hook))

(use-package ledger-mode
  :mode ("\\.ldg\\'" . ledger-mode))

(use-package yasnippet
  :delight yas
  :init
  (setq yas-snippet-dirs '("/etc/nixos/programs/emacs/snippets"))
  :hook
  (after-init . yas-global-mode)
  (yas-global-mode . yas-reload-all))

(use-package himalaya
  :load-path "~/code/pimalaya/himalaya-emacs"
  :init
  (setq himalaya-executable "~/code/pimalaya/himalaya/target/release/himalaya")
  (setq himalaya-config-path "~/.h.toml"))

(use-package org
  :bind
  ("C-c c" . org-capture)
  ("C-c a" . org-agenda)
  :init
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
  :config (use-package org-clock))

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

;;
;; TODO: sort and clean me
;;

;; (global-set-key (kbd "C-c SPC") 'soywod/org-clock-toggle)

;; (require 'prettier-js)
;; (delight 'prettier-js-mode nil 'prettier-js)

;; (require 'web-mode)
;; (define-derived-mode tsx-mode web-mode "TypeScript/React")
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-mode))
;; (cl-defmethod project-root ((project (head eglot-project))) (cdr project))
;; (defun my-project-try-tsconfig-json (dir)
;;   (when-let* ((found (locate-dominating-file dir "tsconfig.json")))
;;     (cons 'eglot-project found)))
;; (add-to-list 'eglot-server-programs '(tsx-mode . ("typescript-language-server" "--stdio")))
;; (add-hook 'project-find-functions
;;           'my-project-try-tsconfig-json nil nil)
;; (add-hook 'tsx-mode-hook 'soywod/eglot-ensure-without-formatting)
;; (add-hook 'tsx-mode-hook 'soywod/default-web-indent-mode)
;; (add-hook 'tsx-mode-hook 'prettier-js-mode)

;; (require 'typescript-mode)
;; (setq typescript-indent-level 2)
;; (setq typescript-auto-indent-flag nil)
;; (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
;; (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server" "--stdio")))
;; (add-hook 'typescript-mode-hook 'soywod/eglot-ensure-without-formatting)
;; (add-hook 'typescript-mode-hook 'prettier-js-mode)

;; scss-mode
;; (add-hook 'scss-mode-hook 'soywod/default-web-indent-mode)
;; (add-hook 'scss-mode-hook 'soywod/eglot-ensure-without-formatting)
;; (add-hook 'scss-mode-hook 'prettier-js-mode)

;; (require 'vimrc-mode)
;; (add-hook 'vimrc-mode-hook 'soywod/eglot-ensure)

;; (require 'lua-mode)
;; (add-hook 'lua-mode-hook 'soywod/eglot-ensure)

;; (require 'ox-latex)
;; (add-to-list 'org-latex-classes '("letter" "\\documentclass{frletter}"))

;; (require 'ox-md)

;; (require 'bbdb)
;; (setq bbdb-file "~/documents/contacts")
;; (setq bbdb-mua-auto-update-p 'query)
;; (bbdb-initialize 'message)
;; (bbdb-mua-auto-update-init 'gnus 'message)

;; (require 'paren)
;; (setq show-paren-delay 0)
;; (add-hook 'after-init-hook 'show-paren-mode)
;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold :slant 'normal)

;; (defun soywod/org-clock-get-table-data (file start end)
;;   (let* ((start (format-time-string (org-time-stamp-format t t) start))
;; 	 (end (format-time-string (org-time-stamp-format t t) end))
;; 	 (params (list :maxlevel 0 :tstart start :tend end)))
;;     (org-clock-get-table-data file params)))

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

;; (defun round-price (price)
;;   (/ (fround (* 100 price)) 100))

;; (defun org-dblock-write:invoice (params)
;;   (let* ((file (or (plist-get params :file) (buffer-file-name)))
;;          (rate (plist-get params :rate))
;;          (start (time-convert (org-matcher-time (plist-get params :tstart))))
;;          (end (time-convert (org-matcher-time (plist-get params :tend))))
;; 	 (total-time 0)
;; 	 (total-vat-excl 0)
;; 	 (total-vat 0))
;;     (insert "|Jour"
;; 	    "|Durée"
;; 	    "|Montant\n"
;; 	    "|-\n"
;; 	    "|<l>"
;; 	    "|<r>"
;; 	    "|<r>\n")
;;     (while (time-less-p start end)
;;       (let* ((next-day (time-add start (* 60 60 24)))
;; 	     (time (org-clock-sum start next-day))
;; 	     (amount (round-price (/ (float (* time rate)) 60))))
;; 	(unless (zerop time)
;; 	  (setq total-time (+ total-time time))
;; 	  (setq total-vat-excl (+ total-vat-excl amount))
;; 	  (insert "|" (format-time-string "%a %d" start)
;; 		  "|" (org-duration-from-minutes time '((special . h:mm)))
;; 		  "|" (calc-eval (number-to-string amount))
;; 		  "|\n"))
;; 	(setq start next-day)))
;;     (org-table-align)
;;     (setq total-vat (round-price (* 0.2 total-vat-excl)))
;;     (insert "\n"
;; 	    "|Total\n"
;; 	    "|-\n"
;; 	    "|<l>"
;; 	    "|<r>\n"
;; 	    "|Durée"
;; 	    "|" (org-duration-from-minutes total-time '(("j" . true) (special . h:mm))) "\n"
;; 	    "|HT"
;; 	    "|" (calc-eval (number-to-string total-vat-excl)) "\n"
;; 	    "|TVA 20%"
;; 	    "|" (calc-eval (number-to-string total-vat)) "\n"
;; 	    "|TTC"
;; 	    "|" (calc-eval (number-to-string (+ total-vat-excl total-vat))) "\n")
;;     (org-table-align)))

;; Local packages

;; (add-to-list 'load-path "~/code/org-latex-invoice")
;; (require 'org-latex-invoice)

;; reset garbage collector threashold
(setq gc-cons-threshold (* 2 1000 1000))
