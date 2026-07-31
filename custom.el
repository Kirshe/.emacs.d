;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f9575ecd8da2a02c114e427f2ebb49ffee94285c5963f33a0abf357c5a33a1d9"
     "488b82a8d9ace0aea8a6825db144e3c65c4f1ef3e090b618bf311d9cdb513322"
     "17570f818a8a3877994453342e3425a3b4fa4b3ebac050b4ecbbee958f1ca133"
     "6dcf1ca4c7432773084b9d52649ee5eb2c663131c4c06859f648dea98d9acb3e"
     "c8078cccd38e52c3f94822b0b2bbe83886dea993536acfde2db019f46a193503"
     "fff0dc54ff5a194ba6593d1cce0fbb4fe8cf9da59fcef47f9e06dec6ef11b1fa"
     "8eabe9aa600059ad7c1c110c35a98f8601b17d3f44efc526250671ad5b5ac1cf"
     "3799f9b2e997c7cf7d1a5d9846095c8976bce96852eda40d8bf9248157c2615f"
     default))
 '(package-selected-packages
   '(corfu csv-mode dired-subtree dumb-jump eat embark-consult fzf magit
	   marginalia markdown-mode multiple-cursors nim-mode
	   orderless rainbow-delimiters rg standard-themes treemacs
	   treesit-fold undo-fu vertico vterm))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; NOTE: the `default' face used to be set here with a display spec of t,
;; which applies to terminal frames too.  The font now lives in
;; elisp/my-display.el (`my/font-family'), applied only to graphical
;; frames.  Setting a font through the Customize UI will write it back
;; here, but my-display.el runs later and overrides it on graphical
;; frames -- so change `my/font-family' instead, or scope any entry
;; written here with `((type graphic))'.
