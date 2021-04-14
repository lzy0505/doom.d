;; -*- no-byte-compile: t; -*-
;;; lang/coq/packages.el

(package! proof-general :recipe
  (:host github
   :repo "lzy0505/PG"
   :branch "async")
  )
(package! company-coq :pin "7423ee253951a439b2491e1cd2ea8bb876d25cb7")
