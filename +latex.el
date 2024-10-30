;;; ~/src/doom/+latex.el -*- lexical-binding: t; -*-

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

(map! :after preview
      :map LaTeX-mode-map
      :localleader
      ;; :prefix ("p" . "Texpresso")
      :desc "Open Texpresso"     "p" #'texpresso
      :desc "Move to cursor"     "." #'texpresso-move-to-cursor)
