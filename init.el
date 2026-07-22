
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))


(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))
(require 'my-functions)
(require 'lang-common)
(require 'lang-python)
(require 'lang-web)
(require 'lang-yaml)

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
   (dired-mode . hl-line-mode))
  :config
  (setq dired-listing-switches "-l"))

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

(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode)
  :bind ("C-c t" . eat-project))

(use-package csv-mode
  :ensure t
  :mode ("\\.csv\\'" . csv-mode)
  :hook (csv-mode . csv-align-mode))

(use-package fzf
  :ensure t
  :init
  (bind-keys :prefix "C-x f"
	     :prefix-map fzf-prefix-map
	     ("f" . fzf-find-file)
	     ("s" . fzf-git-grep))
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
	fzf/grep-command "rg --no-heading -nH"
        fzf/position-bottom t
        fzf/window-height 15))

(use-package standard-themes
  :ensure t
  :init
  (load-theme 'standard-light-tinted :no-confirm)
  :config
  (require 'standard-themes))

(use-package undo-fu
  :ensure t
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package treesit-fold
  :ensure t
  :straight (treesit-fold :type git :host github :repo "emacs-tree-sitter/treesit-fold"))

;; To be run
;; (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))
