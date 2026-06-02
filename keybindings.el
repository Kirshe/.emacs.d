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

; Source - https://stackoverflow.com/a/60826269
; Posted by Ryan Marcus
; Retrieved 2026-06-03, License - CC BY-SA 4.0
(defun ryanmarcus/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-back "[ \n]")
               (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))

(defun my/isearch-repeat-or-word-at-point ()
  "In isearch, if search string is empty, yank word at point instead of last search; otherwise go to next match."
  (interactive)
  (if (string= isearch-string "")
      (let ((word (thing-at-point 'word t)))
        (if word
            (isearch-yank-string word)
          (isearch-repeat-forward)))
    (isearch-repeat-forward)))

(defun my/move-line-up ()
  "Move the current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun my/move-line-down ()
  "Move the current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

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

(provide 'keybindings)
;;; keybindings.el ends here
