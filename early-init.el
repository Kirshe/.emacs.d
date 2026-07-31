;;; early-init.el --- Pre-GUI initialization -*- lexical-binding: t -*-

;; Chrome only exists on graphical frames; on a TTY the menu bar just
;; eats a screen row and the scroll bar is meaningless.
;; NB: `display-graphic-p' is not usable here -- the initial frame does not
;; exist yet during early-init, so it reports nil even in a GUI session.
;; `initial-window-system' is the reliable test.
(tool-bar-mode -1)
(when initial-window-system
  (menu-bar-mode 1)
  (scroll-bar-mode 1))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq scroll-conservatively 101)
(setq scroll-margin 0)

;; NOTE: do *not* set `term-file-prefix' to nil.  That stops Emacs loading
;; term/tmux.el and term/xterm.el, which are what provide modifier keys
;; (M-<up>, C-<backspace>, S-TAB, ...), bracketed paste, focus tracking
;; and window-title support in the terminal.
;;
;; For 24-bit colour in the TUI, tell the *terminal* about it rather than
;; Emacs -- Emacs takes its colour count from terminfo.  Run with
;; TERM=xterm-direct, or inside tmux:
;;     set -g default-terminal "tmux-direct"
;;     set -as terminal-features ",*:RGB"
;; Both "tmux-direct" and "xterm-direct" still resolve to the tmux/xterm
;; term files, so key handling is preserved.

;;; early-init.el ends here
