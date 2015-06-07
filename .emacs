(add-to-list 'load-path "~/.emacs.d/lisp")

;; Disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; hideshow (hs-minor-mode) configuration
(add-hook 'c-mode-common-hook (lambda () (hs-minor-mode t)))

(add-hook 'hs-minor-mode-hook (lambda ()
                                (define-key hs-minor-mode-map "\C-ch"
                                  'hs-hide-block)
                                (define-key hs-minor-mode-map "\C-cs"
                                  'hs-show-block)
                                (define-key hs-minor-mode-map "\C-cH"
                                  'hs-hide-all)
                                (define-key hs-minor-mode-map "\C-cS"
                                  'hs-show-all)))

;; I prefer using the "clipboard" selection (the one the typically is
;; used by c-c/c-v) before the primary selection (that uses
;; mouse-select/middle-button-click)
;; http://hugoheden.wordpress.com/2009/03/08/copypaste-with-emacs-in-terminal/
(setq x-select-enable-clipboard t)

;; If emacs is run in a terminal, the clipboard- functions have no
;; effect; use xsel instead.
;; http://shreevatsa.wordpress.com/2006/10/22/emacs-copypaste-and-x
;; http://www.mail-archive.com/help-gnu-emacs@gnu.org/msg03577.html
(unless window-system
  ;; Callback for when user cuts
  (defun xsel-cut-function (text &optional push)
    ;; Insert text to temp-buffer, and "send" content to xsel stdin
    (with-temp-buffer
      (insert text)
      ;; I prefer using the "clipboard" selection (the one the
      ;; typically is used by c-c/c-v) before the primary selection
      ;; (that uses mouse-select/middle-button-click)
      (call-process-region
       (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  ;; Callback for when user pastes
  (defun xsel-paste-function()
    ;; Find out what is current selection by xsel. If it is different
    ;; from the top of the kill-ring (car kill-ring), then return
    ;; it. Else, nil is returned, so whatever is in the top of the
    ;; kill-ring will be used.
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      (unless (string= (car kill-ring) xsel-output)
	xsel-output )))
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

;; ledger cli emacs mode http://github.com/jwiegley/ledger
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
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; START Org mode settings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-switchb)

(setq org-completion-use-ido t)
(setq org-todo-keywords
  '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "VOID(v)")))
(setq org-enforce-todo-dependencies t)
(setq org-log-into-drawer t)
;; END Org mode settings

;; Load host-specific configuration
(let ((local-config "~/.emacs_local"))
  (if (file-exists-p local-config)
      (load-file local-config)))

;; Thunar file manager integration
(defun thunar ()
  "Start an instance of thunar in the present directory."
  (interactive)
  (start-process "thunar-process" nil "thunar"))

(global-set-key "\C-ce" 'thunar)
