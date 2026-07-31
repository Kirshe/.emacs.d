;;; my-display.el --- Display-aware appearance and terminal support -*- lexical-binding: t; -*-

;; Settings that must differ between graphical and terminal frames: theme,
;; font, cursor, mouse and clipboard.
;;
;; Everything is applied per-frame rather than once at startup, so it
;; behaves correctly under `emacs --daemon' where graphical and terminal
;; frames coexist in one process.

;;; Theme

(defvar my/theme 'standard-light-tinted
  "Theme to enable on capable displays.")

(defvar my/theme-min-colors 256
  "Minimum colour count a terminal must report before `my/theme' is used.
Below this, Emacs has to approximate every theme colour into a tiny
palette, which usually reads worse than the terminal's own default
faces.  Applies only to terminal frames.")

(defun my/theme-usable-p (frame)
  "Return non-nil when FRAME can render `my/theme' acceptably."
  (or (display-graphic-p frame)
      (>= (display-color-cells frame) my/theme-min-colors)))

(defun my/enable-theme (&optional frame)
  "Enable `my/theme' if FRAME can render it.
Safe to call repeatedly; loading is skipped once the theme is active."
  (let ((frame (or frame (selected-frame))))
    (when (and (my/theme-usable-p frame)
               (not (memq my/theme custom-enabled-themes)))
      (load-theme my/theme :no-confirm)
      ;; The theme is light.  Say so explicitly: on a terminal Emacs
      ;; otherwise infers the background mode from TERM and often guesses
      ;; "dark", which makes every face that adapts via
      ;; `((class color) (background dark))' choose the wrong colours.
      (setq frame-background-mode 'light)
      (mapc #'frame-set-background-mode (frame-list)))))

;;; Font

(defvar my/font-family "Adwaita Mono"
  "Default font family for graphical frames.
Terminal frames render in whatever font the terminal emulator is
configured with -- Emacs has no say -- so this is never applied to them.")

(defvar my/font-height 143
  "Default font height for graphical frames, in 1/10 pt.")

(defun my/set-font (frame)
  "Apply `my/font-family' to FRAME when it is graphical and has that font.
Set frame-locally, so terminal frames in the same daemon are untouched."
  (when (and (display-graphic-p frame)
             (member my/font-family (font-family-list frame)))
    (set-face-attribute 'default frame
                        :family my/font-family
                        :height my/font-height)))

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

(defun my/setup-frame (frame)
  "Apply display-appropriate settings to FRAME."
  (with-selected-frame frame
    (my/enable-theme frame)
    (if (display-graphic-p frame)
        (my/set-font frame)
      ;; Reclaim the screen row the menu bar would take.  Set this as a
      ;; frame parameter rather than calling `menu-bar-mode', which is
      ;; global and would strip the menu from GUI frames too when a daemon
      ;; is serving both kinds at once.
      (set-frame-parameter frame 'menu-bar-lines 0)
      (set-frame-parameter frame 'tool-bar-lines 0)
      ;; Cursor.  `cursor-type' is a no-op on a terminal -- shape is the
      ;; emulator's business -- but these two are not:
      ;;   - `visible-cursor' nil stops Emacs requesting the terminal's
      ;;     "very visible" (blinking block) cursor, so the cursor you
      ;;     configured in your terminal is the one you get.
      ;;   - a hollow cursor drawn in every other window is noise when
      ;;     there is only one real hardware cursor to follow.
      (setq visible-cursor nil)
      (setq-default cursor-in-non-selected-windows nil)
      (blink-cursor-mode -1)
      ;; Mouse: click to move point, drag to select, wheel to scroll.
      ;; Global, but a no-op on graphical frames.
      (xterm-mouse-mode 1)
      (when my/tty-clipboard-command
        (setq interprogram-cut-function #'my/tty-cut-function)))))

(defun my/display-setup ()
  "Configure all frames, now and for any frame created later."
  ;; Terminal bell is an audible beep with no useful visible equivalent;
  ;; silence it.
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
  (mapc #'my/setup-frame (frame-list))
  (add-hook 'after-make-frame-functions #'my/setup-frame))

(my/display-setup)

(provide 'my-display)
;;; my-display.el ends here
