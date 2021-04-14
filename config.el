;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zongyuan Liu"
      user-mail-address "zy.liu@cs.au.dk")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Fira Code" :size 16))
;;      doom-variable-pitch-font (font-spec :family "sans" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-Iosvkem)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; to get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'k' (non-evil users must press 'c-c c k').
;; this will open documentation for it, including demos of how they are used.
;;
;; you can also try 'gd' (or 'c-c c d') to jump to their definition and see how
;; they are implemented.

;; (setq frame-resize-pixelwise t)
;; (toggle-frame-maximized)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(with-eval-after-load 'treemacs
  (add-to-list 'treemacs-pre-file-insert-predicates #'treemacs-is-file-git-ignored?))

;; bug fix
(use-package-hook! evil
  :pre-init
  (setq evil-want-abbrev-expand-on-insert-exit nil)
  t)


;;Latex mode
(setq +latex-viewers '(skim))

(add-hook! 'TeX-mode-hook
    (lambda ()
        (add-to-list 'TeX-output-view-style
            '("^pdf$" "."
              "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
)


;;Coq mode

;; disable pretyify symbols
;; (with-eval-after-load 'company-coq
  ;; (add-to-list 'company-coq-disabled-features 'prettify-symbols))

;; keymap
(map! (:when (featurep! :lang coq)
       (:map proof-mode-map
        :n "C-'" #'proof-assert-next-command-interactive
        :n "C-;" #'proof-undo-last-successful-command
        :n "C-," #'proof-goto-point)))


;;C mode

;; (setq ccls-executable "/usr/local/Cellar/ccls/0.20190823.6/bin/ccls")


;;tab
(setq centaur-tabs-set-icons nil
        centaur-tabs-height 28
        centaur-tabs-set-bar 'under
        )

;;sync PATH
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
