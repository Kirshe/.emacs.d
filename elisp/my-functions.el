;;; my-functions.el --- Custom keyboard functions

(require 'cl-lib)

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

(defun my/send-region-to-eat ()
  "Send the selected region text to the eat terminal buffer in the current project."
  (interactive)
  (unless (use-region-p)
    (user-error "No region selected"))
  (let* ((text (buffer-substring-no-properties (region-beginning) (region-end)))
         (project (project-current t))
         (default-directory (project-root project))
         (eat-buf (seq-find (lambda (buf)
                              (with-current-buffer buf
                                (and (derived-mode-p 'eat-mode)
                                     (string-prefix-p (project-root project)
                                                      default-directory))))
                            (buffer-list))))
    (unless eat-buf
      (user-error "No eat terminal found for current project"))
    (with-current-buffer eat-buf
      (eat-term-send-string eat-terminal text)
      (eat-term-send-string eat-terminal "\n")))
  (deactivate-mark))

(defun my/org-babel-execute:plantuml-unicode (orig-fun body params)
  "Run PlantUML as Unicode text when Babel is not writing an image file.

Verbatim results otherwise use a temp `.txt' file (`-ttxt', ASCII)."
  (if (member "file" (cdr (assq :result-params params)))
      (funcall orig-fun body params)
    (let ((real-temp (symbol-function 'org-babel-temp-file)))
      (cl-letf (((symbol-function 'org-babel-temp-file)
                 (lambda (prefix &optional suffix)
                   (funcall real-temp prefix
                            (if (and (string= prefix "plantuml-")
                                     (equal suffix ".txt"))
                                ".utxt"
                              suffix)))))
        (funcall orig-fun body params)))))

(defun my/org-tty-chafa-art (file)
  "Return FILE rendered as terminal character art, or nil."
  (when (and (not (display-graphic-p))
             (executable-find "chafa")
             (file-readable-p file))
    (require 'ansi-color)
    (let* ((width (max 40 (window-body-width)))
           (height (max 20 (/ (window-body-height) 2)))
           (exit 0)
           (art
            (with-temp-buffer
              (setq exit
                    (call-process
                     "chafa" nil t nil
                     "-f" "symbols"
                     "-c" "256"
                     "--animate" "off"
                     "--relative" "off"
                     "--probe" "off"
                     "-s" (format "%dx%d" width height)
                     (expand-file-name file)))
              (when (and (zerop exit) (> (buffer-size) 0))
                (ansi-color-apply-on-region (point-min) (point-max))
                (buffer-string)))))
      (and art (string-trim-right art)))))

(defun my/org-link-preview-file (orig-fun ov path link)
  "Preview PATH in OV using chafa when Emacs cannot display images."
  (or (funcall orig-fun ov path link)
      (when-let* ((file (substitute-in-file-name (expand-file-name path)))
                  ((string-match-p (image-file-name-regexp) file))
                  ((file-exists-p file))
                  (art (my/org-tty-chafa-art file)))
        (overlay-put ov 'display art)
        (overlay-put ov 'face 'default)
        t)))

(defun my/org-babel-tty-preview-images ()
  "After Babel, preview image file results in a terminal frame."
  (when (and (derived-mode-p 'org-mode)
             (not (display-graphic-p)))
    (save-excursion
      (when-let* ((beg (org-babel-where-is-src-block-result)))
        (goto-char beg)
        (org-link-preview-region nil t beg (org-babel-result-end))))))

(provide 'my-functions)
;;; my-functions.el ends here
