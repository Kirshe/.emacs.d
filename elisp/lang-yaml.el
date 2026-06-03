;;; lang-yaml.el --- YAML language support -*- lexical-binding: t; -*-

(use-package yaml-ts-mode
  :ensure nil
  :mode ("\\.ya?ml\\'" . yaml-ts-mode))

;; Language server for YAML
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(yaml-ts-mode . ("yaml-language-server" "--stdio"))))

(provide 'lang-yaml)
;;; lang-yaml.el ends here
