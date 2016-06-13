#lang racket/base
; binary-tree.rkt
(require racket/generator
         racket/match
         racket/contract)
(provide (struct-out btree)
         (struct-out node)
         (contract-out
          [make-tree (-> any/c (-> any/c any/c boolean?) btree?)]
          [make-tree-eq (-> any/c (-> any/c any/c boolean?) btree?)]
          [make-tree-eqv (-> any/c (-> any/c any/c boolean?) btree?)]
          [make-custom-tree (-> any/c
                                (-> any/c any/c boolean?)
                                (-> any/c any/c boolean?)
                                btree?)]
          [tree-equal? (-> btree? boolean?)]
          [tree-eq? (-> btree? boolean?)]
          [tree-eqv? (-> btree? boolean?)]
          [tree=? (-> btree? btree? boolean?)]
          [tree-add (-> btree? any/c ... btree?)]
          [tree-add! (-> btree? any/c ... void?)]
          [tree-contains? (-> btree? any/c boolean?)]
          [tree-copy (-> btree? btree?)]
          [tree-mirror (-> btree? btree?)]
          [tree-cons (-> btree? btree? btree?)]
          [tree-append (-> btree? btree? btree?)]
          [tree-append! (-> btree? btree? void?)]
          [in-tree (-> btree? sequence?)]
          [tree->list (-> btree? list?)]
          [tree-length (-> btree? exact-nonnegative-integer?)]
          [tree-branch (-> btree? any/c btree?)]
          [tree-remove (-> btree? any/c btree?)]
          [tree-remove! (-> btree? any/c void?)]))

(struct btree (root <? =?) #:mutable #:transparent)

(struct node (data left right) #:mutable #:transparent)

(define (make-tree data <?)
  (btree (node data null null) <? equal?))

(define (make-tree-eq data <?)
  (btree (node data null null) <? eq?))

(define (make-tree-eqv data <?)
  (btree (node data null null) <? eqv?))

(define (make-custom-tree data <? =?)
  (btree (node data null null) <? =?))

(define (tree-equal? tree)
  (match tree
    [(btree _ <? =?)
     (eq? =? equal?)]))

(define (tree-eq? tree)
  (match tree
    [(btree _ _ =?)
     (eq? =? eq?)]))

(define (tree-eqv? tree)
  (match tree
    [(btree _ _ =?)
     (eq? =? eqv?)]))

(define (tree=? t1 t2)
  (match t1
    [(btree root _ =?)
     (if (= (tree-length t1) (tree-length t2))
         (null? (node=? root (btree-root t2) =?))
         #f)]))

(define (node=? r1 r2 =?)
  (cond [(null? r1) null]
        [(null? r2) null]
        [else
         (define r1-data (node-data r1))
         (define r2-data (node-data r2))
         (cond [(=? r1-data r2-data)
                (node=? (node-left r1) (node-left r2) =?)
                (node=? (node-right r1) (node-right r2) =?)]
               [else (begin #f)])]))

(define tree-add
  (case-lambda
    [(tree val)
     (match tree
       [(btree root <? =?)
        (btree (node-add root val <? =?) <? =?)])]
    [(tree . vals)
     (match tree
       [(btree root <? =?)
        (for/fold ([accum tree])
                  ([val (in-list vals)])
          (tree-add accum val))])]))

(define tree-add!
  (case-lambda
    [(tree val)
     (match tree
       [(btree root <? =?)
        (set-btree-root! tree (node-add root val <? =?))])]
    [(tree . vals)
     (for ([val (in-list vals)])
       (tree-add! tree val))]))

(define (node-add root val <? =?)
  (match root
    [(node data left right)
     (cond [(=? data val) (node val left right)]
           [(<? val data)
            (node data
                  (node-add left val <? =?)
                  right)]
           [else
            (node data
                  left
                  (node-add right val <? =?))])]
    [else (node val null null)]))

(define (tree-contains? tree val)
  (match tree
    [(btree root <? =?)
     (node-contains? root val <? =?)]))

(define (node-contains? root val <? =?)
  (match root
    [(node data left right)
     (cond [(=? val data) (begin #t)]
           [(<? val data)
            (node-contains? left val <? =?)]
           [else
            (node-contains? right val <? =?)])]
    [else #f]))

(define (tree-copy tree)
  (match tree
    [(btree root <? =?)
     (btree root <? =?)]))

(define (tree-mirror tree)
  (match tree
    [(btree root <? =?)
     (btree (node-mirror root) <? =?)]))

(define (node-mirror root)
  (match root
    [(node data left right)
     (node data (node-mirror right) (node-mirror left))]
    [else null]))

; tree-cons - just places t2 on the right side of t1
(define (tree-cons t1 t2)
  (match t1
    [(btree root <? =?)
     (btree (node-cons root (btree-root t2)) <? =?)]))

(define (node-cons r1 r2)
  (if (null? r1)
      r2
      (node (node-data r1)
            (node-left r1)
            (node-cons (node-right r1) r2))))

; add all the values from t2 to t1
(define (tree-append t1 t2)
  (for/fold ([accum t1])
            ([t2 (in-tree t2)])
    (tree-add accum t2)))

(define (tree-append! t1 t2)
  (for/fold ([accum t1])
            ([t2 (in-tree t2)])
    (tree-add! accum t2)))

(define (in-tree tree)
  (match tree
    [(btree root _ _)
     (in-node root)]
    [else (in-list null)]))

(define (in-node tree)
  (in-generator
   (let iterate ([parent tree])
     (match parent
       [(node data left right)
        (iterate left)
        (yield data)
        (iterate right)]
       [else #t]))))

(define (tree->list tree)
  (for/list ([x (in-tree tree)]) x))

(define (tree-length tree)
  (length (tree->list tree)))

(define (tree-branch tree val)
  (match tree
    [(btree root <? =?)
     (btree (node-branch root val =?) <? =?)]))

(define (node-branch root val =?)
  (let loop ([parent root])
    (match parent
      [(node data left right)
       (cond [(=? val data) parent]
             [else
              (loop left)
              (loop right)])]
      [else (node val null null)])))

(define (tree-remove tree val)
  (match tree
    [(btree root <? =?)
     (when (tree-contains? tree val)
       (btree (node-remove root <? =? val) <? =?))]))

(define (tree-remove! tree val)
  (match tree
    [(btree root <? =?)
     (when (tree-contains? tree val)
       (set-btree-root! tree (node-remove root <? =? val)))]))

(define (node-remove root <? =? val)
  (match root
    [(node data left right)
     (cond [(tree-contains? (btree root <? =?) val)
            (define old-branch (tree-branch (btree root <? =?) val))
            (define new-branch (tree-append
                                (node-left (btree-root old-branch))
                                (node-right (btree-root old-branch))))
            (define removed (remove-branch root val <? =?))
            (tree-append removed new-branch)]
           [else root])]
    [else null]))

(define (remove-branch tree val <? =?)
  (match tree
    [(node data left right)
     (if (=? val data)
         null
         (node data
               (remove-branch left val <? =?)
               (remove-branch right val <? =?)))]
    [else null]))
