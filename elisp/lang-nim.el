;;; lang-nim.el --- Nim language support -*- lexical-binding: t; -*-

;; nimble installs binaries (e.g. nimlangserver) under ~/.nimble/bin, which is
;; not on the systemd Emacs daemon's PATH by default. Make sure Emacs can find them.
(let ((nimble-bin (expand-file-name "~/.nimble/bin")))
  (when (file-directory-p nimble-bin)
    (add-to-list 'exec-path nimble-bin)
    (setenv "PATH" (concat nimble-bin path-separator (getenv "PATH")))))

(use-package nim-mode
  :ensure t
  :mode ("\\.nim\\'" "\\.nims\\'" "\\.nimble\\'")
  :hook (nim-mode . eglot-ensure)
  :config
  ;; Use nimlangserver as the language server
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((nim-mode nimscript-mode) . ("nimlangserver")))))

(provide 'lang-nim)
;;; lang-nim.el ends here
