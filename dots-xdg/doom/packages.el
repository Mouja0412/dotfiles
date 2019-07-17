;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)
;; (package! hunspell)
(package! conda)

;; (def-package! pdf-tools
;;   :if (display-graphic-p)
;;   :mode ("\\.pdf$" . pdf-view-mode)
;;   :init (load "pdf-tools-autoloads" nil t)
;;   :config (pdf-tools-install))
