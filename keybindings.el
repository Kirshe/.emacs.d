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

(defun my/isearch-repeat-or-word-at-point ()
  "In isearch, if search string is empty, yank word at point instead of last search; otherwise go to next match."
  (interactive)
  (if (string= isearch-string "")
      (let ((word (thing-at-point 'word t)))
        (if word
            (isearch-yank-string word)
          (isearch-repeat-forward)))
    (isearch-repeat-forward)))

(defun my/eat-project-claude ()
  "Open eat-project terminal and run the claude command."
  (interactive)
  (eat-project)
  (let ((buf (current-buffer)))
    (run-with-timer 0.5 nil
      (lambda ()
        (when-let ((process (get-buffer-process buf)))
          (process-send-string process "claude\n"))))))

;; Global keybindings
(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
(define-key global-map (kbd "C-z") #'undo)
(define-key global-map (kbd "C-;") #'comment-line)
(define-key isearch-mode-map (kbd "C-s") #'my/isearch-repeat-or-word-at-point)
(define-key global-map (kbd "C-c t") #'my/eat-project-claude)

(provide 'keybindings)
;;; keybindings.el ends here
