#lang racket/base
; binary-tree/graphics.rkt
(require pict
         pict/tree-layout
         racket/class
         racket/contract
         racket/draw
         racket/format
         racket/match
         "base.rkt")
(provide (contract-out
          [tree->pict (->* (btree?)
                           (#:color string?
                            #:style procedure?)
                           pict?)])
         (all-from-out pict/tree-layout))

(define (tree->pict tree #:color [color "black"] #:style [style naive-layered])
  (match tree
    [(btree root <? =?)
     (style (node->pict root (make-object color% color)))]))

(define (node->pict root color)
  (match root
    [(node data left right)
     (tree-layout #:pict (text (~v data) (list color))
                  (node->pict left color)
                  (node->pict right color))]
    [else #f]))
