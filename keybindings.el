;;; keybindings.el --- Custom keybindings

;; Global keybindings
(define-key global-map (kbd "M-<up>")    #'my/move-line-up)
(define-key global-map (kbd "M-<down>")  #'my/move-line-down)
(define-key global-map (kbd "M-<right>") #'transpose-words)
(define-key global-map (kbd "M-<left>")  (lambda () (interactive) (transpose-words -1)))
(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
;; (define-key global-map (kbd "C-z") #'undo)
(define-key global-map (kbd "C-;") #'comment-line)
;; (define-key isearch-mode-map (kbd "C-s") #'my/isearch-repeat-or-word-at-point)
(define-key global-map (kbd "C-<backspace>") #'ryanmarcus/backward-kill-word)
(define-key global-map (kbd "C-c C-y") #'my/send-region-to-eat)

(provide 'keybindings)
;;; keybindings.el ends here
