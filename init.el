;;                             __         __
;;                            |  |-     -|  |
;;                            | °_°|   |O-X |
;;                            ---------------
;;                           ~|P3R7's .emacs|~
;;

;; { Init }----------------------------------------------------------------[#I]

(setq
 auto-save-default nil
 backup-inhibited t)

(global-set-key (kbd "C-<f1>")
  (lambda()(interactive)(find-file "~/.emacs.d/init.el")))

(let* ((my-lisp-dir "~/.emacs.d/plugins/")
        (default-directory my-lisp-dir))
  (setq load-path (cons my-lisp-dir load-path))
  (normal-top-level-add-subdirs-to-load-path))

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "C-z")
		(lambda()(interactive)
		  (unless window-system (suspend-frame))
		  ))

(global-set-key (kbd "\C-x\C-z")
		(lambda()(interactive)
		  (unless window-system (suspend-frame))
		  ))


;; { Edition }-------------------------------------------------------------[#E]

(global-font-lock-mode t)
;(setq require-final-newline t)           ;; end files with a newline

(global-set-key (kbd "C-<f8>") 'comment-or-uncomment-region)


;; Selection mode
(cua-selection-mode t)
(global-set-key (kbd "C-<f4>") 'delete-selection-mode)

;; Improved copy/cut/comment
;; still not as good as C-k
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))
(defadvice comment-or-uncomment-region (before slickcut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; Smart parenthesis
;; parentheses highlighting
(setq show-paren-delay 0)
(show-paren-mode t)
;(setq show-paren-style 'expression)
(setq show-paren-style 'parenthesis)
(set-face-background 'show-paren-match-face "#aaaaaa")
(set-face-attribute 'show-paren-match-face nil
        :weight 'bold :underline nil :overline nil :slant 'normal)
;; - brackets completion
(require 'autopair)
(eval-after-load "autopair"
  '(progn
     (autopair-global-mode 1)
     (setq autopair-autowrap t)))

;; Delete trailling whitespaces before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)



;; { Navigation }----------------------------------------------------------[#N]

(global-set-key "\C-x\C-k" 'kill-buffer)
(global-set-key (kbd "C-x C-B") 'ibuffer)
(global-set-key (kbd "C-x C-b")   'switch-to-buffer)

(global-set-key [f10] 'list-bookmarks)
(global-set-key (kbd "C-<f10>") 'bookmark-set)
(setq
  bookmark-default-file "~/.emacs.d/bookmarks" ;; keep my ~/ clean
  bookmark-save-flag 1)                        ;; autosave each change)

(require 'windmove)
(eval-after-load "windmove"
  '(windmove-default-keybindings 'super))
(global-set-key (kbd "<C-s-down>")      'split-window-vertically)
(global-set-key (kbd "<C-s-right>")     'split-window-horizontally)
(global-set-key (kbd "<C-s-left>")      'delete-other-windows)
(global-set-key (kbd "<C-s-up>")        'delete-window)

;; (when (require 'goto-last-change nil 'noerror)
;;   (global-set-key [(meta p)(u)] 'goto-last-change))

;; <http://www.cabochon.com/~stevey/blog-rants/my-dot-emacs-file.html>
;; TODO:
;; - write original name by default
;; - autocomplete
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it is visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))
(global-set-key "\C-x\ W" 'rename-file-and-buffer)



;; { Appearance }----------------------------------------------------------[#A]

(display-battery-mode)

;; Disable visual elements
(menu-bar-mode -1)
(global-set-key (kbd "C-<f2>") 'menu-bar-mode)
(tool-bar-mode -1)
(global-set-key (kbd "M-<f2>") 'tool-bar-mode)
(set-scroll-bar-mode 'nil)
(blink-cursor-mode -1)
(setq-default initial-scratch-message ";;                               Hello Master\n\n")

(setq
 ring-bell-function 'ignore
 frame-title-format "%b"   ;; current buffer name in title bar
 inhibit-startup-message   t
 inhibit-startup-echo-area-message t
;; Mini Buffer
; enable-recursive-minibuffers nil    ;; don't allow mb cmds in the mb
 resize-mini-windows  t             ;; mb resize itself atomatically
 max-mini-window-height .25 ;; max 2 lines
 )

(column-number-mode t)                ;; display column number in mb

(require 'color-theme)
(require 'color-theme-solarized)
(eval-after-load "color-theme"
  '(progn
;;     (color-theme-initialize)
;;      (color-theme-comidia)
;;      (color-theme-solarized-light)
;;     (color-theme-solarized-dark)
     ))

;; (require 'auto-complete-config)
;; (ac-config-default)
;; (define-key ac-mode-map (kbd "<M-S-iso-lefttab>") 'auto-complete)

;; (server-start)

;; (require 'server)
;; (defun emacsclient-done ()
;;   (interactive)
;;   (server-edit)
;;   (make-frame-invisible nil t))
;; (global-set-key (kbd "C-x C-c") 'emacsclient-done)