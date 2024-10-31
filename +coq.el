;;; ~/.doom.d/+coq.el -*- lexical-binding: nil; -*-
;;;

(use-package! proof-general
  :config
  ;; (setq proof-auto-raise-buffers nil)
  ;; (setq proof-delete-empty-windows t)
  ;; (setq proof-three-window-enable t)
  ;; (setq proof-multiple-frames-enable t)
  (setq proof-three-window-mode-policy 'hybrid)
  ;;(setq undo-tree-enable-undo-in-region nil)

  (let ((coqbin (getenv "COQBIN")))
    (setq coq-compiler (concat coqbin "coqc"))
    (setq coq-dependency-analyzer (concat coqbin "coqdep"))
    (setq coq-prog-name (concat coqbin "dune-coqtop")))
  (setq coq-prefer-top-of-conclusion t)
  (setq proof-electric-terminator-enable nil)
  (setq coq-double-hit-enable nil)

  (setq coq-smie-user-tokens
   '(("," . ":=")
	("∗" . "->")
	("-∗" . "->")
	("∗-∗" . "->")
	("==∗" . "->")
	("=∗" . "->")  ;; Hack to match ={E1,E2}=∗
	("|==>" . ":=")
	("⊢" . "->")
	("⊣⊢" . "->")
	("↔" . "->")
	("←" . "<-")
	("→" . "->")
	("=" . "->")
	("==" . "->")
	("/\\" . "->")
	("⋅" . "->")
	(":>" . ":=")
	("by" . "now")
	("forall" . "now")
      ))
  )

(after! company-coq
  (setq company-coq-prettify-symbols-alist '(;; Disabled
                                             ;; ("*" . ?×)  ; Inconsistent (‘intros H *’, rewrite in *, etc.)
                                             ;; ("~" . ?¬)  ; Too invasive
                                             ;; ("+-" . ?±) ; Too uncommon
                                             ;; ("++" . ?⧺) ; Not present in TeX fonts
                                             ;; ("nat" . ?𝓝) ("Prop" . ?𝓟) ; Rather uncommon
                                             ;; ("N" . ?ℕ) ("Z" . ?ℤ) ("Q" . ?ℚ) ; Too invasive

                                             ;; Core Coq symbols
                                             ;; ("|-" . ?⊢) ("||" . ?‖) ("/\\" . ?∧) ("\\/" . ?∨)
                                             ("->" . ?→) ("<-" . ?←) ("<->" . ?↔) ("=>" . ?⇒)
                                             ("<=" . ?≤) (">=" . ?≥) ("<>" . ?≠)
                                             ;; ("True" . ?⊤) ("False" . ?⊥)
                                             ;; ("fun" . ?λ) ;; ("forall" . ?∀) ("exists" . ?∃)
                                             ;; ("Prop" . ?ℙ)
                                             ;; ("nat" . ?ℕ) ("Prop" . ?ℙ) ("Real" . ?ℝ) ("bool" . ?𝔹)

                                             ;; Extra symbols
                                             (">->" . ?↣)
                                             ("-->" . ?⟶) ("<--" . ?⟵) ("<-->" . ?⟷)
                                             ("==>" . ?⟹) ("<==" . ?⟸) ("~~>" . ?⟿) ("<~~" . ?⬳)))
  (setq company-coq-live-on-the-edge t)
  (setq company-coq-disabled-features
        '(hello
          outline
          refactorings
          alerts ;; doesn't work on macOS
          ;; prettify-symbols ;; causes too many problems with Iris
          spinner ;; minor modes are hidden anyway
          obsolete-settings
          unicode-math-backend ;; use input method instead
          ))
  )

(add-hook! coq-mode
  (setq proof-splash-seen t)

  (evil-define-text-object evil-a-lift (count &optional beg end type)
   "Select a lifted proposition."
   :extend-selection nil
   (evil-select-paren ?⌜ ?⌝ beg end type count t))

  (evil-define-text-object evil-inner-lift (count &optional beg end type)
   "Select inner lifted proposition."
   :extend-selection nil
   (evil-select-paren ?⌜ ?⌝ beg end type count))

  (define-key evil-inner-text-objects-map "l" 'evil-inner-lift)
  (define-key evil-outer-text-objects-map "l" 'evil-a-lift)

  ;; auto-indentation in Coq isn't good enough to use electric indentation
  (electric-indent-mode -1)

  (setq require-final-newline t)
  )

(when (modulep! :config default +smartparens)
  (after! smartparens
    (sp-with-modes '(coq-mode)
      ;; Disable ` because it is used in implicit generalization
      (sp-local-pair "`" nil :actions nil)
      (sp-local-pair "(*" "*)" :actions nil)
      (sp-local-pair "(*" "*"
                     :actions '(insert)
                     :post-handlers '(("| " "SPC") ("|\n[i]*)[d-2]" "RET")))
      )))

(map! :map coq-mode-map
      :ni "<f3>" #'proof-assert-next-command-interactive
      :ni "<f4>" #'proof-goto-point
      :ni "<f2>" #'proof-undo-last-successful-command

      :localleader
      :desc "Go to point"                "." #'proof-goto-point

      :prefix ("p" . "Proof process")
      :desc "Kill Coq process"           "x" #'proof-shell-exit
      :desc "Interrupt Coq"              "c" #'proof-interrupt-process
      :desc "Retract proof"              "r" #'proof-retract-buffer
      :desc "Process buffer"             "b" #'proof-process-buffer

      :prefix ("l" . "PG window layout")
      :desc "Re-layout windows"          "l" #'proof-layout-windows
      :desc "Clear response buffer"      "c" #'pg-response-clear-displays
      :desc "Show proof state"           "p" #'proof-prf

      :prefix ("a" . "Query Coq")
      :desc "Check"                      "c" #'coq-Check
      :desc "Print"                      "p" #'coq-Print
      :desc "About"                      "b" #'coq-About
      :desc "Locate Constant"            "l" #'coq-LocateConstant
      :desc "Locate Notation"            "n" #'coq-LocateNotation
      :desc "Search"                     "s" #'coq-Search
      :desc "Search Pattern"             "S" #'coq-SearchIsos

      :prefix ("ai" . "Query Coq with implicits")
      :desc "Check with implicits"       "c" #'coq-Check-show-implicits
      :desc "Print with implicits"       "p" #'coq-Print-with-implicits
      :desc "About with implicits"       "b" #'coq-About-with-implicits
      )

(defun iris-input-config ()
  "Set up math input for Iris. Based on https://gitlab.mpi-sws.org/iris/iris/blob/master/docs/editor.md"

  ;; Input method for the minibuffer
  (defun my-inherit-input-method ()
    "Inherit input method from `minibuffer-selected-window'."
    (let* ((win (minibuffer-selected-window))
           (buf (and win (window-buffer win))))
      (when buf
        (activate-input-method (buffer-local-value 'current-input-method buf)))))
  (add-hook 'minibuffer-setup-hook #'my-inherit-input-method)
  ;; Define the actual input method
  (quail-define-package "math" "UTF-8" "Ω" t)
  (quail-define-rules ; add whatever extra rules you want to define here...
   ;; LaTeX math rules
   ("\\forall"         "∀")
   ("\\exists"         "∃")
   ("\\not"            "¬")
   ;("\\/"              "∨")
   ;("/\\"              "∧")
   ;("->"               "→")
   ;("<->"              "↔")
   ("\\<-"             "←") ;; we add a backslash because the plain <- is used for the rewrite tactic
   ("\\=="             "≡")
   ("\\/=="            "≢")
   ("\\neq"               "≠")
   ;("<="               "≤")
   ("\\in"             "∈")
   ("\\notin"          "∉")
   ("\\cup"            "∪")
   ("\\cap"            "∩")
   ("\\union"          "∪")
   ("\\intersect"      "∩")
   ("\\setminus"       "∖")
   ("\\subset"         "⊂")
   ("\\subseteq"       "⊆")
   ("\\sqsubseteq"     "⊑")
   ("\\sqsubseteq"     "⊑")
   ("\\notsubseteq"    "⊈")
   ("\\meet"           "⊓")
   ("\\join"           "⊔")
   ("\\top"            "⊤")
   ("\\bottom"         "⊥")
   ("\\vdash"          "⊢")
   ("\\dashv"          "⊣")
   ("\\bient"          ["⊣⊢"])
   ("\\Vdash"          "⊨")
   ("\\infty"          "∞")
   ("\\comp"           "∘")
   ("\\prf"            "↾")
   ("\\bind"           ["≫="])
   ("\\mapsto"         "↦")
   ("\\hookrightarrow" "↪")
   ("\\uparrow"        "↑")
   ("\\upclose"        "↑")
   ("\\named"          "∷")

   ("\\mult"   ?⋅)
   ("\\ent"    ?⊢)
   ("\\valid"  ?✓)
   ("\\box"    ?□)
   ("\\bbox"   ?■)
   ("\\later"  ?▷)
   ("\\pred"   ?φ)
   ("\\post"   ?Φ)
   ("\\phi"    ?Φ)
   ("\\and"    ?∧)
   ("\\or"     ?∨)
   ("\\land"   ?∧)
   ("\\lor"    ?∨)
   ("\\comp"   ?∘)
   ("\\ccomp"  ?◎)
   ("\\all"    ?∀)
   ("\\ex"     ?∃)
   ("\\to"     ?→)
   ("\\arr"    ?→)
   ("\\sep"    ?∗)
   ("\\ast"    ?∗)
   ("\\lc"     ?⌜)
   ("\\rc"     ?⌝)
   ("\\lam"    ?λ)
   ("\\fun"    ?λ)
   ("\\empty"  ?∅)
   ("\\Lam"    ?Λ)
   ("\\Sig"    ?Σ)
   ("\\env"    ?Δ)
   ("\\state"  ?σ)
   ("\\-"      ?∖)
   ("\\aa"     ?●)
   ("\\af"     ?◯)
   ("\\iff"    ?↔)
   ("\\gname"  ?γ)
   ("\\incl"   ?≼)
   ("\\latert" ?▶)
   ("\\now"  ?⋈)

   ;; accents (for iLöb)
   ("\\\"o"    ?ö)
   ("\\Lob"    ?ö)

   ;; subscripts and superscripts
   ("^^+" ?⁺) ("__+" ?₊) ("^^-" ?⁻)
   ("__0" ?₀) ("__1" ?₁) ("__2" ?₂) ("__3" ?₃) ("__4" ?₄)
   ("__5" ?₅) ("__6" ?₆) ("__7" ?₇) ("__8" ?₈) ("__9" ?₉)

   ("__a" ?ₐ) ("__e" ?ₑ) ("__h" ?ₕ) ("__i" ?ᵢ) ("__k" ?ₖ)
   ("__l" ?ₗ) ("__m" ?ₘ) ("__n" ?ₙ) ("__o" ?ₒ) ("__p" ?ₚ)
   ("__r" ?ᵣ) ("__s" ?ₛ) ("__t" ?ₜ) ("__u" ?ᵤ) ("__v" ?ᵥ) ("__x" ?ₓ)

   ;; Greek alphabet
   ("\\Alpha"    "Α") ("\\alpha"    "α")
   ("\\Beta"     "Β") ("\\beta"     "β")
   ("\\Gamma"    "Γ") ("\\gamma"    "γ")
   ("\\Delta"    "Δ") ("\\delta"    "δ")
   ("\\Epsilon"  "Ε") ("\\epsilon"  "ε")
   ("\\Zeta"     "Ζ") ("\\zeta"     "ζ")
   ("\\Eta"      "Η") ("\\eta"      "η")
   ("\\Theta"    "Θ") ("\\theta"    "θ")
   ("\\Iota"     "Ι") ("\\iota"     "ι")
   ("\\Kappa"    "Κ") ("\\kappa"    "κ")
   ("\\Lamda"    "Λ") ("\\lamda"    "λ")
   ("\\Lambda"   "Λ") ("\\lambda"   "λ")
   ("\\Mu"       "Μ") ("\\mu"       "μ")
   ("\\Nu"       "Ν") ("\\nu"       "ν")
   ("\\Xi"       "Ξ") ("\\xi"       "ξ")
   ("\\Omicron"  "Ο") ("\\omicron"  "ο")
   ("\\Pi"       "Π") ("\\pi"       "π")
   ("\\Rho"      "Ρ") ("\\rho"      "ρ")
   ("\\Sigma"    "Σ") ("\\sigma"    "σ")
   ("\\Tau"      "Τ") ("\\tau"      "τ")
   ("\\Upsilon"  "Υ") ("\\upsilon"  "υ")
   ("\\Phi"      "Φ") ("\\phi"      "φ")
   ("\\Chi"      "Χ") ("\\chi"      "χ")
   ("\\Psi"      "Ψ") ("\\psi"      "ψ")
   ("\\Omega"    "Ω") ("\\omega"    "ω")

   ;; custom
   ("\\gets"     ?←)
   ("\\op"       ?⋅)
   ("\\except0"  ?◇)
   ("\\times"   ?×)
   ("\\rbl"   "⦗")
   ("\\rbr"   "⦘")
   ("\\rbb"   ["⦗⦘"])
   ("\\rseq"   "⨾")
   ;; note that this is a elisp vector - quail interprets a string as a list of
   ;; characters that are candidates for translation, while a vector can contain
   ;; strings that are candidates for translation.
   ("\\bient"    ["⊣⊢"])
   ;; common typo due to keyboard config
   ;; ("\\_ep"    ?∗)
   ("\\lvl" "ℓ")
   ("\\uplvl" "ℒ")
   ;; ("\\tto" ["Τₒ"])
   ;; ("\\tte" ["Τₑ"])
   )

)

;; define new math mode
(iris-input-config)

(use-package! opam-switch-mode
  :hook (coq-mode . opam-switch-mode)
  :init
  (defadvice! +ocaml--init-opam-switch-mode-maybe-h (fn &rest args)
    "Activate `opam-switch-mode' if the opam executable exists."
    :around #'opam-switch-mode
    (when (executable-find opam-switch-program-name)
      (apply fn args)))
  ;; :config
  ;; ;; Use opam to set environment
  ;; (setq tuareg-opam-insinuate t)
  ;; (opam-switch-set-switch (tuareg-opam-current-compiler))
  )

(add-hook! coq-mode
  ; use the newly-created math input method
  (set-input-method "math")
)

;; FIXES
;;
;; the regular smie-config-guess takes forever in Coq mode due to some advice
;; added by Doom; replace it with a constant
(defun my-smie-config-guess ()
  (if (equal major-mode 'coq-mode) 2 nil))
(advice-add 'smie-config-guess
            :before-until #'my-smie-config-guess)

;; don't show auxiliary files in treemacs
(with-eval-after-load 'treemacs
  (defun treemacs-ignore-coq (filename absolute-path)
    (or (string-suffix-p ".vo" filename)
        (string-suffix-p ".vos" filename)
        (string-suffix-p ".vok" filename)
        (string-suffix-p ".aux" filename)
        (string-suffix-p ".glob" filename)))

  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-coq))

;; fix company-coq loading, from https://github.com/hlissner/doom-emacs/pull/2857
;;
;; `+company-init-backends-h' in `after-change-major-mode-hook' overrides
;; `company-backends' set by `company-coq' package. This dirty hack fixes
;; completion in coq-mode. TODO: remove when company backends builder is
;; reworked.
(defvar-local +coq--company-backends nil)
(after! company-coq
  (defun +coq--record-company-backends-h ()
    (setq +coq--company-backends company-backends))
  (defun +coq--replay-company-backends-h ()
    (setq company-backends +coq--company-backends))
  (add-hook! 'company-coq-mode-hook
    (defun +coq--fix-company-coq-hack-h ()
      (add-hook! 'after-change-major-mode-hook :local #'+coq--record-company-backends-h)
      (add-hook! 'after-change-major-mode-hook :append :local #'+coq--replay-company-backends-h))))
