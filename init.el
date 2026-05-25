
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(load-file (locate-user-emacs-file "keybindings.el"))

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
  :custom
  (vterm-kill-buffer-on-exit t)
  (vterm-min-window-width 80)
  :config
  ;; Light/white mode colors for better readability
  (set-face-attribute 'vterm-color-default nil :foreground "#222222" :background "#ffffff")
  (set-face-attribute 'vterm-color-black nil :foreground "#333333" :background "#ffffff")
  (set-face-attribute 'vterm-color-white nil :foreground "#eeeeee" :background "#ffffff")
  (set-face-attribute 'vterm-color-bright-black nil :foreground "#666666" :background "#ffffff")
  (set-face-attribute 'vterm-color-bright-white nil :foreground "#ffffff" :background "#ffffff")

  ;; Set other colors for better contrast in light mode
  (set-face-attribute 'vterm-color-red nil :foreground "#d70000" :background "#ffffff")
  (set-face-attribute 'vterm-color-green nil :foreground "#00aa00" :background "#ffffff")
  (set-face-attribute 'vterm-color-yellow nil :foreground "#b38800" :background "#ffffff")
  (set-face-attribute 'vterm-color-blue nil :foreground "#0087ff" :background "#ffffff")
  (set-face-attribute 'vterm-color-magenta nil :foreground "#d700d7" :background "#ffffff")
  (set-face-attribute 'vterm-color-cyan nil :foreground "#00aaaa" :background "#ffffff"))

(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode))

(use-package csv-mode
  :ensure t
  :mode ("\\.csv\\'" . csv-mode)
  :hook (csv-mode . csv-align-mode))
