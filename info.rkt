#lang setup/infotab

(define name "binary-tree")
(define scribblings '(("doc/binary-tree.scrbl" ())))

(define blurb '("Binary Tree implementation"))
(define primary-file "main.rkt")
(define homepage "https://github.com/lehitoskin/binary-tree/")

(define version "0.1")
(define release-notes '("Initial commit."))

(define required-core-version "6.0")

(define deps '("base"
               "scribble-lib"
               "pict-lib"))
(define build-deps '("racket-doc"))
