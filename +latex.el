;;; ~/src/doom/+latex.el -*- lexical-binding: t; -*-

(map! :map LaTeX-mode-map
      :localleader
      :prefix ("p" . "Preview")
      :desc "Preview Buffer"     "b" #'preview-buffer
      :desc "Clear previews"     "c" #'preview-clearout)

(setq +latex-viewers '(skim))
(add-hook! 'TeX-mode-hook
    (lambda ()
        (add-to-list 'TeX-output-view-style
            '("^pdf$" "."
              "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o")))

    )
;; Auto-raise Emacs on activation
(defun raise-emacs-on-aqua()
    (shell-command "osascript -e 'tell application \"Emacs\" to activate' &"))
(add-hook 'server-switch-hook 'raise-emacs-on-aqua)

(use-package! texpresso)
