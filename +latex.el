;;; ~/src/doom/+latex.el -*- lexical-binding: t; -*-

;; Use skim as the default viewer
;; (setq +latex-viewers '(skim))

(defun my-LaTeX-mode ()
  (add-to-list 'TeX-view-program-list '("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o"))
  (setq TeX-view-program-selection '((output-pdf "Skim")))
  )

(add-hook! 'TeX-mode-hook 'my-LaTeX-mode)

;; Auto-raise Emacs on activation, so that skim can invoke emacs
(defun raise-emacs-on-aqua()
    (shell-command "osascript -e 'tell application \"Emacs\" to activate' &"))

(add-hook 'server-switch-hook 'raise-emacs-on-aqua)

;; Use Texpresso to preview
(use-package! texpresso)

(map! :after preview ; override default keybindings for preview
      :map LaTeX-mode-map
      :localleader
      :desc "Open Texpresso"     "p" #'texpresso
      :desc "Move to cursor"     "." #'texpresso-move-to-cursor
      :desc "Next page"          "]" #'texpresso-next-page
      :desc "Previous page"      "[" #'texpresso-previous-page
      )

;; fix doom emacs issue for emacs version < 30
;; https://github.com/doomemacs/doomemacs/issues/8191
(setq major-mode-remap-alist major-mode-remap-defaults)
