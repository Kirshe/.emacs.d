
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))


(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode)))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  (:map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))

(use-package paren
  :ensure nil
  :hook (prog-mode-hook . show-paren-mode))

(use-package dumb-jump
  :ensure t
  :custom
  (dumb-jump-prefer-searcher 'rg)
  (xref-show-definitions-function #'consult-xref)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(use-package multiple-cursors
  :ensure t
  :bind
  (:map global-map
	("C-S-c C-S-c" . mc/edit-lines)
	("C->" . mc/mark-next-like-this)
	("C-<" . mc/mark-previous-like-this)
	("C-c C-<" . mc/mark-all-like-this)))

(use-package icomplete
  :ensure nil
  :hook ((after-init . fido-mode)
         (after-init . fido-vertical-mode))
  :bind (:map icomplete-minibuffer-map
              ("C-j" . icomplete-force-select))
  :custom
  (completion-styles '(substring initials flex))
  (completion-category-defaults nil)
  (completion-cycle-threshold 3)
  (icomplete-compute-delay 0))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc")
  :config
  (setq markdown-header-scaling t)
  (add-to-list 'auto-mode-alist '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode)))

(use-package vterm
  :ensure t
  :config
  (set-face-attribute 'vterm-color-default nil :foreground "#002b36" :background "#fdf6e3")
  (set-face-attribute 'vterm-color-black nil :foreground "#586e75" :background "#eee8d5")
  (set-face-attribute 'vterm-color-white nil :foreground "#002b36" :background "#fdf6e3"))
