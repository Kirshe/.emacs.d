;;; lang-web.el --- JavaScript, TypeScript, React, Angular support -*- lexical-binding: t; -*-

(use-package js
  :ensure nil
  :custom
  (js-indent-level 2))

;; TypeScript/TSX indent level
(setq typescript-ts-mode-indent-offset 2)

;; Language server for JS/TS (typescript-language-server handles JS, TS, React, Angular)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((js-ts-mode typescript-ts-mode tsx-ts-mode) . ("typescript-language-server" "--stdio"))))

(provide 'lang-web)
;;; lang-web.el ends here
