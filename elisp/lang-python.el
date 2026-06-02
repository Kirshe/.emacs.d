;;; lang-python.el --- Python language support -*- lexical-binding: t; -*-

(use-package python
  :ensure nil
  :custom
  (python-indent-offset 4)
  :config
  ;; Use pyright as the language server
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((python-ts-mode python-mode) . ("pyright-langserver" "--stdio")))))

(provide 'lang-python)
;;; lang-python.el ends here
