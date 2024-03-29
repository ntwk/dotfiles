(add-to-list 'load-path "~/.emacs.d/lisp")

;; Disable visual elements.  Some of these settings may also be specified
;; via X resources which in general override init file settings.
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

;; Disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)

;; Disable blinking cursor when running in a text terminal
(setq visible-cursor nil)

;; Don't automatically split windows vertically even if it has many columns
(setq split-width-threshold nil)

;; Emacs 28.2 still displays trailing dashes at the end of the mode
;; line when running in a TTY; remove them.
;; https://emacs.stackexchange.com/q/62714
(setq mode-line-end-spaces nil)

;; Set custom colors to use when running in a TTY
(unless window-system
  ;; Basic face for shadowed text.
  ;; Darken the text of eglot annotations in source code to set them apart
  ;; from regular text.
  (set-face-attribute 'shadow nil
                      :foreground "color-240")
  ;; Face used to highlight matches permanently
  (set-face-attribute 'match nil
                      :background "blue4")
  ;; Basic face for highlighting the region.
  ;; The "extend" attribute extends the highlight beyond the end of line.
  (set-face-attribute 'region nil
                      :extend t :background "blue4"))

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

;; If Emacs is run in a terminal, the clipboard- functions have no
;; effect.  Use xclip-mode to use the GUI clipboard even when Emacs is
;; run in a terminal.
(xclip-mode 1)

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
               '("melpa" . "https://stable.melpa.org/packages/") t))

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
