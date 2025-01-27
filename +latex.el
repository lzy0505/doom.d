;;; ~/src/doom/+latex.el -*- lexical-binding: t; -*-

;; Use skim as the default viewer
;; (setq +latex-viewers '(skim))

(defun my-LaTeX-mode ()
  (add-to-list 'TeX-view-program-list '("Skim" "/Applications/Skim.app/Contents/SharedSupport/displayline -b %n %o %b"))
  (setq TeX-view-program-selection '((output-pdf "Skim")))
  )

(add-hook! 'TeX-mode-hook 'my-LaTeX-mode)

(add-hook! 'LaTeX-mode-hook 'flyspell-mode) ;start flyspell-mode
;; (setq ispell-dictionary "british")    ;set the default dictionary
;; (add-hook! 'LaTeX-mode-hook 'ispell)

(after! ispell
  ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
  ;; dictionary' even though multiple dictionaries will be configured
  ;; in next line.
  (setenv "LANG" "en_GB")
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_GB")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  ;; (ispell-set-spellchecker-params)
  ;; (ispell-hunspell-add-multi-dic "de_DE,de_CH,en_GB,en_US")
  ;; For saving words to the personal dictionary, don't infer it from
  ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
  (setq ispell-personal-dictionary "~/.hunspell_personal")
)

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
