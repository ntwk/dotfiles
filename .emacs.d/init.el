(add-to-list 'load-path "~/.emacs.d/lisp")

;; Disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)

;; Disable blinking cursor when running in a text terminal
(setq visible-cursor nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; Configure the visual styling of GUI Emacs.  See also the Emacs X
;; resources located in either .Xresources or .Xdefaults
(when window-system
  (fringe-mode 0)
  (set-face-attribute 'mode-line nil
                      :foreground "blue" :background "turquoise" :box nil)
  (set-face-attribute 'mode-line-inactive nil
                      :foreground "grey" :background "dimgrey" :box nil)
  (set-face-attribute 'mode-line-highlight nil
                      :foreground "blue" :background "yellow" :box nil))

;; Wrap long lines when in Text mode
(add-hook 'text-mode-hook (lambda () (visual-line-mode t)))

;; hideshow (hs-minor-mode) configuration
(add-hook 'c-mode-common-hook (lambda () (hs-minor-mode t)))

(add-hook 'hs-minor-mode-hook (lambda ()
                                (define-key hs-minor-mode-map "\C-ct"
                                  'hs-toggle-hiding)
                                (define-key hs-minor-mode-map "\C-ch"
                                  'hs-hide-block)
                                (define-key hs-minor-mode-map "\C-cs"
                                  'hs-show-block)
                                (define-key hs-minor-mode-map "\C-cH"
                                  'hs-hide-all)
                                (define-key hs-minor-mode-map "\C-cS"
                                  'hs-show-all)))

;; Use the X CLIPBOARD selection (c-c/c-v) before the PRIMARY
;; selection (mouse-select/middle-click)
;; http://hugoheden.wordpress.com/2009/03/08/copypaste-with-emacs-in-terminal/
(setq x-select-enable-clipboard t)

;; If Emacs is run in a terminal, the clipboard- functions have no
;; effect so use xsel instead.
;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x
;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
(unless window-system
  ;; Callback for cutting text
  (defun xsel-cut-function (text &optional push)
    ;; Insert text to temp-buffer, and pipe content to xsel stdin
    (with-temp-buffer
      (insert text)
      ;; Use the xsel --clipboard switch to operate on the X CLIPBOARD
      ;; selection rather than the PRIMARY selection.
      (call-process-region
       (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  ;; Callback for pasting text
  (defun xsel-paste-function ()
    ;; Find out what is current selection by xsel. If it is different
    ;; from the top of the kill-ring (car kill-ring), then return
    ;; it. Else, nil is returned, so whatever is in the top of the
    ;; kill-ring will be used.
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      (unless (string= (car kill-ring) xsel-output)
	xsel-output)))
  ;; Attach callbacks to hooks
  (setq interprogram-cut-function 'xsel-cut-function)
  (setq interprogram-paste-function 'xsel-paste-function))

;; ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ibuffer-mode
(setq ibuffer-default-sorting-mode 'major-mode)
(global-set-key (kbd "C-x C-b") 'ibuffer-other-window)

;; Add MELPA repository
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/") t))

;; Ledger CLI Emacs mode http://github.com/jwiegley/ledger
(require 'ledger)

;; HTML indent to 4 spaces
(add-hook 'html-mode-hook
          (lambda ()
            ;; Default indentation is usually 2 spaces, changing to 4.
            (set (make-local-variable 'sgml-basic-offset) 4)))

;; Associate .less files with css-mode
(add-to-list 'auto-mode-alist '("\\.less\\'" . css-mode))

;; Function to remove paragraph fill on current paragraph
(defun unfill-paragraph ()
  "Unfill paragraph at or after point."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(global-set-key (kbd "C-M-q") 'unfill-paragraph)

;; START Org mode settings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-switchb)

(setq org-completion-use-ido t)
(setq org-todo-keywords
  '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "VOID(v)")))
(setq org-enforce-todo-dependencies t)
(setq org-log-into-drawer t)
(setq org-src-fontify-natively t)
;; END Org mode settings

;; Load host-specific configuration
(let ((local-config "~/.emacs.d/init_local.el"))
  (if (file-exists-p local-config)
      (load-file local-config)))

;; Thunar file manager integration
(defun thunar ()
  "Start an instance of thunar in the current directory."
  (interactive)
  (call-process "exo-open" nil nil nil "--launch" "FileManager"))

(global-set-key "\C-ce" 'thunar)

;; Create a tmux window in session 0 in the current directory
(defun tmux-new-window ()
  "Create a tmux window in session 0 in the current directory."
  (interactive)
  (call-process "tmux-neww-here" nil nil nil))

(global-set-key "\C-cw" 'tmux-new-window)

;; Use CPerl Mode instead of the default Perl Mode
(mapc
 (lambda (pair)
   (if (eq (cdr pair) 'perl-mode)
       (setcdr pair 'cperl-mode)))
 (append auto-mode-alist interpreter-mode-alist))

;; Use emacs-specific .psqlrc file to disable psql prompts in the SQLi
;; buffer.  This gives prettier output.
(setenv "PSQLRC" "~/.psqlrc_emacs")
