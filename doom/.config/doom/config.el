;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; A lot of this is sourced various configs b/c I still need to learn Emacs.
;;   https://github.com/hlissner/doom-emacs-private/
;;   https://github.com/rschmukler/doom.d

(setq user-full-name "John Muchovej"
      user-mail-address "j@ionlights.com"
      epa-file-encrypt-to user-mail-address)

;; UI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Fonts
(setq doom-font (font-spec :family "Fira Code" :size 12)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 14))

(when IS-LINUX
  (font-put doom-font :weight 'semi-light))
(when IS-MAC
  (setq ns-use-thin-smoothing t))

;;; Frames/Windows
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(when IS-MAC
  (add-hook 'window-setup-hook #'toggle-frame-maximized))

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
(require 'conda)
(conda-env-initialize-eshell)
(conda-env-autoactivate-mode t)
(custom-set-variables
    '(conda-anaconda-home "/Users/ionlights/.conda/envs"))

;; Line Numbering
(setq display-line-numbers-type 'relative)

;; Autocomplete
(require 'company)

(after! company
  (setq company-idle-delay 0.01
        company-minimum-prefix-length 3))
