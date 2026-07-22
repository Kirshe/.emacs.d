;;; setup.el --- Install tree-sitter grammars and language servers -*- lexical-binding: t; -*-

(require 'lang-common)

(defun setup-install-tree-sitter-grammars ()
  "Install all tree-sitter grammars from `treesit-language-source-alist'."
  (interactive)
  (dolist (entry treesit-language-source-alist)
    (let ((lang (car entry)))
      (message "Installing tree-sitter grammar: %s" lang)
      (treesit-install-language-grammar lang)))
  (message "All tree-sitter grammars installed."))

(defun setup--run-command (name command &rest args)
  "Run COMMAND with ARGS, displaying output for NAME."
  (message "Installing %s..." name)
  (let ((exit-code (apply #'call-process command nil "*setup*" t args)))
    (if (zerop exit-code)
        (message "Installed %s." name)
      (message "FAILED to install %s (exit code %d)." name exit-code))
    exit-code))

(defun setup-install-language-servers ()
  "Install language servers: pyright, typescript-language-server, yaml-language-server, nimlangserver."
  (interactive)
  (with-current-buffer (get-buffer-create "*setup*")
    (erase-buffer))
  ;; Python: pyright via uv
  (if (executable-find "uv")
      (setup--run-command "pyright" "uv" "tool" "install" "pyright")
    (message "SKIP: pyright — uv not found"))
  ;; JS/TS + YAML via npm
  (if (executable-find "npm")
      (progn
        (setup--run-command "typescript-language-server" "npm" "install" "-g" "typescript-language-server" "typescript")
        (setup--run-command "yaml-language-server" "npm" "install" "-g" "yaml-language-server"))
    (message "SKIP: typescript-language-server, yaml-language-server — npm not found"))
  ;; Nim: nimlangserver via nimble
  (if (executable-find "nimble")
      (setup--run-command "nimlangserver" "nimble" "--accept" "install" "nimlangserver")
    (message "SKIP: nimlangserver — nimble not found"))
  (message "Language server installation complete."))

(defun setup-install-all ()
  "Install all tree-sitter grammars and language servers."
  (interactive)
  (setup-install-tree-sitter-grammars)
  (setup-install-language-servers))

(provide 'setup)
;;; setup.el ends here
