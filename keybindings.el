;;; keybindings.el --- Custom keybindings and keyboard functions

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(defun my/isearch-word-at-point ()
  "Start isearch with the word at point."
  (interactive)
  (let ((word (thing-at-point 'word t)))
    (if word
        (let ((isearch-mode-hook
               (cons (lambda () (isearch-yank-string word))
                     isearch-mode-hook)))
          (isearch-forward))
      (isearch-forward))))

;; Global keybindings
(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
(define-key global-map (kbd "C-z") #'undo)
(define-key global-map (kbd "C-;") #'comment-line)
(define-key global-map (kbd "C-s") #'my/isearch-word-at-point)

(provide 'keybindings)
;;; keybindings.el ends here
