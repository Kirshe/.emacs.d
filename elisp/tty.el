;;; tty.el --- Terminal (TUI) friendliness -*- lexical-binding: t; -*-

;; Everything here is applied per-frame rather than once at startup, so it
;; behaves correctly under `emacs --daemon' where graphical and terminal
;; frames coexist in one process.

;;; System clipboard

;; In a terminal, Emacs has no window-system selection.  Pasting *into*
;; Emacs is handled by the terminal itself (bracketed paste, via
;; term/xterm.el), so only the copy direction needs wiring up.

(defvar my/tty-clipboard-command
  (cond
   ((executable-find "wl-copy")  '("wl-copy" "--trim-newline"))
   ((executable-find "xclip")    '("xclip" "-selection" "clipboard"))
   ((executable-find "xsel")     '("xsel" "--clipboard" "--input"))
   ;; WSL: clip.exe accepts UTF-8 on current Windows builds.
   ((executable-find "clip.exe") '("clip.exe")))
  "Command used to push text to the system clipboard from a TTY frame.
Nil when no suitable helper is installed.")

(defun my/tty-cut-function (text)
  "Send TEXT to the system clipboard via `my/tty-clipboard-command'."
  (when my/tty-clipboard-command
    (let ((coding-system-for-write 'utf-8))
      (ignore-errors
        (apply #'call-process-region text nil
               (car my/tty-clipboard-command) nil nil nil
               (cdr my/tty-clipboard-command))))))

;;; Per-frame setup

(defun my/tty-setup-frame (frame)
  "Apply terminal-only settings to FRAME when it is a TTY frame."
  (with-selected-frame frame
    (unless (display-graphic-p frame)
      ;; Reclaim the screen row the menu bar would take.  Set this as a
      ;; frame parameter rather than calling `menu-bar-mode', which is
      ;; global and would strip the menu from GUI frames too when a daemon
      ;; is serving both kinds at once.
      (set-frame-parameter frame 'menu-bar-lines 0)
      (set-frame-parameter frame 'tool-bar-lines 0)
      ;; Mouse: click to move point, drag to select, wheel to scroll.
      ;; Global, but a no-op on graphical frames.
      (xterm-mouse-mode 1)
      ;; A blinking block cursor in a terminal fights the terminal's own
      ;; cursor and forces needless redraws.
      (blink-cursor-mode -1)
      (when my/tty-clipboard-command
        (setq interprogram-cut-function #'my/tty-cut-function)))))

(defun my/tty-setup ()
  "Configure terminal frames, now and for any frame created later."
  ;; Terminal bell is an audible beep with no way to make it visible in a
  ;; useful way; silence it.
  (setq ring-bell-function #'ignore
        visible-bell nil)
  ;; Wheel events arrive as button 4/5 under xterm-mouse-mode.
  (setq mouse-wheel-scroll-amount '(3 ((shift) . 1))
        mouse-wheel-progressive-speed nil)
  ;; Terminals cannot show a fringe indicator, so wrapped lines need a
  ;; visible marker in the text area itself.
  (setq-default visual-line-fringe-indicators '(nil nil))
  ;; Let a mouse click select a window and a drag set the region.
  (setq mouse-drag-copy-region nil
        select-active-regions nil)
  (mapc #'my/tty-setup-frame (frame-list))
  (add-hook 'after-make-frame-functions #'my/tty-setup-frame))

(my/tty-setup)

(provide 'tty)
;;; tty.el ends here
