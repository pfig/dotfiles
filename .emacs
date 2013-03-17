;;;;;;;;;;
;; Paths
;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/Nav/")
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized/")
(add-to-list 'load-path "~/.emacs.d/auto-complete-1.2/")
(add-to-list 'load-path "~/.emacs.d/yasnippet/")
(setq exec-path (cons (expand-file-name "~/.rbenv/shims") exec-path))

;;;;;;;;;;
;; Solarized
;;;;;;;;;;
(require 'color-theme)
(require 'color-theme-solarized)
(setq solarized-termcolors 256)
(color-theme-solarized-dark)

;;;;;;;;;;
;; Interface tweaks
;;;;;;;;;;

;; Visible bell
(setq visible-bell t)

;; Remap the alt key to be able to type in the hash
(setq mac-option-modifier nil)
(setq mac-function-modifier 'meta)

;; Always use spaces for indentation
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; Auto-indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Yank and indent
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
     (and (not current-prefix-arg)
    (member major-mode '(emacs-lisp-mode lisp-mode
                 ruby-mode python-mode
                 perl-mode cperl-mode
                 c-mode latex-mode
                 plain-text-mode))
    (let ((mark-even-if-inactive transient-mark-mode))
      (indent-region (region-beginning) (region-end) nil))))))

;; Kill and join line (if at the end)
(defun kill-and-join-forward (&optional arg)
  "If at end of line, join with following; otherwise kill line.
Deletes whitespace at join."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (delete-indentation t)
    (kill-line arg)))

;; Enable syntax highlighting
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode 1)
  (setq font-lock-auto-fontify t))

;; Remove trailing whitespace before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Delete blank lines at the end of the document
(defun my-delete-trailing-blank-lines ()
  "Deletes all blank lines at the end of the file."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (goto-char (point-max))
      (delete-blank-lines))))
(add-hook 'before-save-hook 'my-delete-trailing-blank-lines)

;; Keymap for outline-minor-mode (folding)
(define-prefix-command 'cm-map nil "Outline-")
                                        ; HIDE
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
                                        ; SHOW
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
                                        ; MOVE
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(global-set-key "\M-o" cm-map)

;;;;;;;;;;
;; Growl support
;; N.B. requires growlnotify
;;;;;;;;;;
(defun growl-chat (title message &optional sticky)
  (interactive "sTitle: \nsGrowl: ")
  (shell-command
   (format "/usr/local/bin/growlnotify %s -m '%s' --appIcon 'Aquamacs Emacs' %s" title message (if sticky "--sticky" ""))))

;; Sticky notifications
(defun growl-chat-sticky (title message)
  (interactive "sTitle: \nsGrowl: ")
  (growl-chat title message t))

;;
;; ERC notifications
;; Growl nicknames and highlight words when they are mentioned on IRC.
;; Nickname notifications are sticky.
(add-hook 'erc-text-matched-hook
    (lambda (match-type nickuserhost message)
      (when (and
       (boundp 'nick)
       (not (string= nick "ChanServ"))
       (not (string= nick "services.")))
        (cond
         ((eq match-type 'current-nick)
    (growl-chat-sticky (format "%s said %s" nick (erc-current-nick)) message))
         ((eq match-type 'keyword)
    (growl-chat (format "%s mentioned a Keyword" nick) message))))))

;;;;;;;;;;
;; Writeroom
;;;;;;;;;;
(defun writeroom()
  "Switches to a Writeroom-like fullscreen style"
  (interactive)
  (when (featurep 'aquamacs)
    ;; switch to white on black
    (color-theme-initialize)
    (color-theme-clarity)
    ;; switch to Garamond 36pt
    (aquamacs-autoface-mode 0)
    (set-frame-font "-apple-garamond-medium-r-normal--36-360-72-72-m-360-iso10646-1")
    ;; switch to fullscreen mode
    (aquamacs-toggle-full-frame)))

;;;;;;;;;;
;; Iconify from fullscreen mode
;;;;;;;;;;
(defun iconify-or-deiconify-frame-fullscreen-even ()
  (interactive)
  (if (eq (cdr (assq 'visibility (frame-parameters))) t)
      (progn
  (if (frame-parameter nil 'fullscreen)
      (aquamacs-toggle-full-frame))
  (switch-to-buffer "*scratch*")
  (iconify-frame))
    (make-frame-visible)))
(define-key global-map "\C-z" #'iconify-or-deiconify-frame-fullscreen-even)

;;;;;;;;;;
;; Open files in same frame, but keep Cmd-N
;; Similarly, clse frames with Cmd-w
;;;;;;;;;;
(one-buffer-one-frame-mode 0)
(defun my-new-frame-with-new-scratch ()
  (interactive)
  (let ((one-buffer-one-frame t))
    (new-frame-with-new-scratch)))
(define-key osx-key-mode-map (kbd "A-n") 'my-new-frame-with-new-scratch)

;; I actually want Cmd-w to close the buffer, not the window
(define-key osx-key-mode-map (kbd "A-w") 'kill-this-buffer)

;;;;;;;;;;
;; Use "Open" in Dired
;;;;;;;;;;
(require 'dired)
(defun dired-open-mac ()
  (interactive)
  (let ((file-name (dired-get-file-for-visit)))
    (if (file-exists-p file-name)
  (call-process "/usr/bin/open" nil 0 nil file-name))))
(define-key dired-mode-map "o" 'dired-open-mac)

;; Nav
(require 'nav)

;; Auto-complete goodness
;; must find/write Perl dictionary for this but cperl-electric might suffice
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete-1.2/dict")
(ac-config-default)

;;;;;;;;;;
;; Snippets
;;;;;;;;;;
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
(yas/global-mode 1)

;;;;;;;;;;
;; Python
;;;;;;;;;;
(require 'pymacs)
;; Refactoring!
;; requires rope and ropemacs
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
;; Django
(setq mumamo-background-colors nil)
(add-to-list 'auto-mode-alist '("\\.html\\'" . django-html-mumamo-mode))
;; Code checking
;; requires pycheckers in the Emacs executable paths
;; requires pyflakes and pep8
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)

;;;;;;;;;;
;; Perl
;;;;;;;;;;

;; cperl goodness
(defalias 'perl-mode 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.pl\\'" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . perl-mode))
(autoload 'perl-mode "perl-mode" "Perl editing mode." t)
(add-hook 'cperl-mode-hook
          (lambda ()
            (local-set-key (kbd "C-h f") 'cperl-perldoc)))
(setq cperl-invalid-face nil) ;; no underlines where there is trailing whitespace
(setq cperl-electric-keywords t) ;; expand keywords
(setq cperl-electric-parens t) ;; auto-parens
(setq cperl-font-lock t) ;; syntax highlighting
(setq cperl-auto-newline t)

;; Find Perl modules
(defun perl-module-path (module-name)
  (let* ((file-name
          (concat (replace-regexp-in-string "::" "/" module-name)
                  ".pm"))
         (command-line
          (concat "perl -M'"
                  module-name
                  "' -e 'print $INC{q{"
                  file-name
                  "}}'"))
         (path (shell-command-to-string command-line))
         (cant-locate (string-match "^Can't locate " path)))
    if (cant-locate
        nil
        path)))

(defun find-perl-module (module-name)
  (interactive "sPerl module name: ")
  (let ((path (perl-module-path module-name)))
    (if path
        (find-file path)
      (error "Module '%s' not found" module-name))))

;; Use outline-minor-mode for folding
(defmacro join (join-char &rest others) `(mapconcat 'identity ',others ,join-char))
(setq my-cperl-outline-regexp
      (concat
       "^"                              ; Start of line
       "[ \\t]*"                        ; Skip leading whitespace
       "\\("                            ; begin capture group \1
       (join "\\|"
             "=head[12]"                  ; POD header
             "package"                    ; package
             "=item"                      ; POD item
             "sub"                        ; subroutine definition
             )
       "\\)"                            ; end capture group \1
       "\\b"                            ; Word boundary
       ))

;; Override cperl's outline
(setq cperl-mode-hook 'my-cperl-customizations)

(defun my-cperl-customizations ()
  "cperl-mode customizations that must be done after cperl-mode loads"
  (outline-minor-mode)
  (abbrev-mode)

  (defun cperl-outline-level ()
    (looking-at outline-regexp)
    (let ((match (match-string 1)))
      (cond
       ((eq match "=head1" ) 1)
       ((eq match "package") 2)
       ((eq match "=head2" ) 3)
       ((eq match "=item"  ) 4)
       ((eq match "sub"    ) 5)
       (t 7)
       )))

  (setq cperl-outline-regexp  my-cperl-outline-regexp)
  (setq outline-regexp        cperl-outline-regexp)
  (setq outline-level        'cperl-outline-level)
  )


;;;;;;;;;;
;; SQL
;;;;;;;;;;
;; I want .hql and .q files to use sql-mode
(add-to-list 'auto-mode-alist '("\\.hql\\'" . sql-mode))
(add-to-list 'auto-mode-alist '("\\.q\\'" . sql-mode))
(autoload 'sql-mode "sql-mode" "SQL editing mode." t)
(setq sql-mode-hook 'my-sql-customisations)
(defun my-sql-customisations ()
  "sql-mode customisations that must be done after sql-mode loads"
  (add-to-list 'same-window-buffer-names "*SQL*")
  (setq tab-width 2))

;;;;;;;;;;
;; Pig
;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.pig\\'" . pig-mode))
(autoload 'pig-mode "pig-mode.elc" "Pig Latin editing mode." t)

;; Git commit messages
(add-to-list 'auto-mode-alist '(".*_EDITMSG\\'" . log-entry-mode))

;; Markdown
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdwn\\'" . markdown-mode))
(autoload 'markdown-mode "markdown-mode.elc" "Major mode for editing Markdown files" t)
(defun markdown-custom ()
  "markdown-mode-hook"
  (setq markdown-command "markdown | smartypants"))
(add-hook 'markdown-mode-hook '(lambda() (markdown-custom)))
(add-hook 'markdown-mode-hook
          (lambda ()
            (when buffer-file-name
              (add-hook 'after-save-hook
                        'check-parens
                        nil t))))
(add-hook 'markdown-mode-hook
          (lambda ()
            (modify-syntax-entry ?\" "\"" markdown-mode-syntax-table)))

;;;;;;;;;;
;; Less
;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))
(autoload 'less-css-mode "less-css-mode.el" "Major mode for editing Less CSS files" t)

;;

;; Set the font to Andale Mono 16pt
(set-default-font "-apple-Andale_Mono-medium-normal-normal-*-16-*-*-*-m-0-iso10646-1")

(server-start)
