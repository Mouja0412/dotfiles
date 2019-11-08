;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; A lot of this is sourced various configs b/c I still need to learn Emacs.
;;   https://github.com/hlissner/doom-emacs-private/
;;   https://github.com/rschmukler/doom.d

(setq user-full-name "John Muchovej"
      user-mail-address "j@ionlights.com"
      epa-file-encrypt-to user-mail-address)

;; UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; Fonts
(setq doom-font (font-spec :family "Fira Code" :size 12)
      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))

(when IS-LINUX
  (font-put doom-font :weight 'semi-light))
(when IS-MAC
  (setq ns-use-thin-smoothing t))

;;; Frames/Windows

;; Theme-ing
;; https://github.com/hlissner/emacs-doom-themes#install
(require 'doom-themes)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

(load-theme 'doom-Iosvkem t)
(doom-themes-visual-bell-config)
(doom-themes-neotree-config)
(doom-themes-org-config)

(setq doom-font (font-spec :family "Fira Code" :size 12))

;; Conda
;; (require 'conda)
;; (conda-env-initialize-eshell)
;; (conda-env-autoactivate-mode t)
;; (custom-set-variables
;;     '(conda-anaconda-home "/Users/ionlights/.conda/envs"))

;; Line Numbering
(setq display-line-numbers-type 'relative)

;; Autocomplete
(require 'company)

(after! company
  (setq company-idle-delay 0.01
        company-minimum-prefix-length 3))


;; Exporting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (def-package! ox-hugo
  ;; :config
  ;; (setq org-hugo-export-with-section-numbers nil)

;;; (provide 'config)
;;; config.el ends here

;; Projectile
(setq projectile-project-search-path '("~/odrive/"))
(setq projectile-sort-order 'recently-active)
(setq projectile-completion-system 'ivy)

(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
          (width (string-width s))
          (prefix ())
          (suffix '(?\s (Br . Br)))
          (n 1))
     (while (< n width)
       (setq prefix (append prefix '(?\s (Br . Bl))))
       (setq n (1+ n)))
     (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)
