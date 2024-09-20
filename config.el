;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zongyuan Liu"
      user-mail-address "zy.liu@cs.au.dk")

;; show error traces
;; (setq debug-on-error t)

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
;; (setq doom-font (font-spec :family "Fira Code" :size 18))
     ;; doom-variable-pitch-font (font-spec :family "sans" :size 18))
(setq doom-font (font-spec :family "Iosevka Fixed SS02" :size 18
                           :slant 'normal :weight 'normal ))
(setq doom-big-font (font-spec :family "Iosevka Fixed SS02" :size 22
                               :slant 'normal :weight 'normal))

;; increase font by small increments
(setq doom-font-increment 1)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-Iosvkem)
(setq current-theme-phase 'light)
(setq doom-theme 'doom-one-light)

(defun toggle-theme-phase ()
  "Switch between light and dark themes."
  (interactive)
  (if (eq current-theme-phase 'light)
      (progn
        (setq current-theme-phase 'dark)
        ;; (load-theme 'doom-solarized-dark-high-contrast)
        (load-theme 'doom-dark+)
        )
    (progn
      (setq current-theme-phase 'light)
      (load-theme 'doom-one-light)
      ;; (disable-theme 'doom-solarized-dark-high-contrast)
      )))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/1drv/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq proof-prog-name-guess nil)
(setq which-key-idle-delay 0.7)
(setq dtrt-indent-max-lines 800)
(setq confirm-kill-processes nil)
(setq auto-save-default t)
;; tab indents anywhere in the line (TODO: probably want this only in only
;; programming language major modes, especially Coq but also any language with
;; reliable auto-indentation)
(setq tab-always-indent t)

;; fish doesn't work well with emacs, so use bash
(setq shell-file-name (executable-find "bash"))

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

(setq frame-resize-pixelwise t)
(toggle-frame-maximized)

;; GUI frame adjustments
(setq frame-title-format
      '(""
        "%b"
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format " in [%s]" project-name))))
        " - Doom Emacs"))
(menu-bar-mode)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq projectile-enable-caching t)
(setq projectile-indexing-method 'native)


;; load patches
(load! "+coq.el")
(load! "+bindings.el")
(load! "+latex.el")

(after! eldoc
  (setq eldoc-echo-area-use-multiline-p 5)
  )

;; ocaml
(add-hook! 'tuareg-mode-hook #'merlin-mode)
(add-hook! 'caml-mode-hook #'merlin-mode)
;; Uncomment these lines if you want to enable integration with the corresponding packages
;; (require 'merlin-iedit)       ; iedit.el editing of occurrences
(require 'merlin-company)     ; company.el completion
;; (require 'merlin-ac)          ; auto-complete.el completion
(map! :map merlin-mode-map
      :localleader
      :desc "Locate Definition"                "l" #'merlin-locate
      )
