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

;; Terminal fallbacks.
;;
;; A TTY cannot encode most control-shift and control-punctuation chords:
;; C-;, C->, C-<, C-S-c, C-S-z and C-<backspace> either never reach Emacs
;; or arrive as something else.  These C-c prefixed equivalents use only
;; sequences every terminal can send.  Bound unconditionally so they also
;; work in a daemon serving both GUI and terminal frames.
(define-key global-map (kbd "C-c ;")      #'comment-line)
(define-key global-map (kbd "C-c <up>")   #'my/move-line-up)
(define-key global-map (kbd "C-c <down>") #'my/move-line-down)
(define-key global-map (kbd "C-c DEL")    #'ryanmarcus/backward-kill-word)
(define-key global-map (kbd "C-c u")      #'undo-fu-only-redo)

;; multiple-cursors, which is otherwise all control-shift chords.
(define-key global-map (kbd "C-c m l") #'mc/edit-lines)
(define-key global-map (kbd "C-c m n") #'mc/mark-next-like-this)
(define-key global-map (kbd "C-c m p") #'mc/mark-previous-like-this)
(define-key global-map (kbd "C-c m a") #'mc/mark-all-like-this)

(provide 'keybindings)
;;; keybindings.el ends here
