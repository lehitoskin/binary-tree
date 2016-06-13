#lang racket/base
; test/binary-tree.rkt
(require rackunit "../base.rkt")

(define tree1
  (let ([tree (make-tree 4 <)])
    (tree-add tree 1 0 2 9 6 10)))

(define tree2 (make-tree 4 <))
(tree-add! tree2 1)
(tree-add! tree2 0)
(tree-add! tree2 2)
(tree-add! tree2 9)
(tree-add! tree2 6)
(tree-add! tree2 10)

(define tree3 (tree-append (make-tree 0 <) tree1))

(test-case
 "Constructors"
 (let ([tree-equal (make-tree 0 <)])
   (check-true (tree-equal? tree-equal))
   (check-false (tree-eq? tree-equal))
   (check-false (tree-eqv? tree-equal)))
 (let ([tree-eq (make-tree-eq 0 <)])
   (check-false (tree-equal? tree-eq))
   (check-true (tree-eq? tree-eq))
   (check-false (tree-eqv? tree-eq)))
 (let ([tree-eqv (make-tree-eqv 0 <)])
   (check-false (tree-equal? tree-eqv))
   (check-false (tree-eq? tree-eqv))
   (check-true (tree-eqv? tree-eqv))))

(test-case
 "Equalities"
 (check-true (tree=? tree1 (tree-copy tree1)))
 (check-true (tree=? tree1 tree2))
 (check-eq? tree1 tree1)
 (check-not-eq? tree1 tree2)
 (check-eqv? tree1 tree1)
 (check-not-eqv? tree1 tree2)
 (check-true (tree=? tree1 tree2))
 (check-true (tree=? (make-tree 0 <) (btree (node 0 null null) < equal?)))
 (check-not-equal? tree1 tree3)
 (check-false (tree=? tree1 tree3))
 (check-equal? (tree->list tree1) (tree->list tree3)))

(test-case
 "Functional Functionality"
 (check-true (tree-contains? tree1 4))
 (check-false (tree-contains? tree1 50))
 (check-equal? (tree->list tree1) '(0 1 2 4 6 9 10))
 (check-equal? (tree->list (tree-mirror tree1)) (reverse (tree->list tree1)))
 (check-equal? (tree->list (tree-mirror tree1)) '(10 9 6 4 2 1 0))
 (check-equal? (tree->list (tree-cons tree1 tree2)) (append (tree->list tree1) (tree->list tree2)))
 (let ([tree (tree-add (tree-add (make-tree 50 <) 40) 60)])
   (check-true
    (tree=?
     (tree-append tree
                  (tree-add (tree-add (make-tree 45 <) 6) 89))
     (tree-add (tree-add (tree-add tree 45) 6) 89))))
 (check-true (sequence? (in-tree tree1)))
 (check-true (tree=? (tree-branch tree1 9) (tree-add (tree-add (make-tree 9 <) 6) 10)))
 (check-true (tree-contains? tree1 9))
 (check-false (tree-contains? (tree-remove tree1 9) 9))
 )

#| TODO: Everything |#
(test-case
 "Mutation Functionality"
 (let ([tree (tree-copy tree1)])
   (tree-add! tree 99)
   (check-true (tree-contains? tree 99))
   (check-false (tree-contains? tree1 99))
   (check-true (tree=? tree (tree-add tree1 99)))))

(test-case
 "Custom Functions"
 ; only add even numbers to a tree
 (let ([even<? (λ (x y)
                 (if (even? x)
                     (< x y)
                     (raise-argument-error 'even-tree-add "even?" x)))]
       [even=? (λ (x y)
                 (if (even? x)
                     (= x y)
                     (raise-argument-error 'even-tree-add "even?" x)))])
   (define tree (make-custom-tree 2 even<? even=?))
   (tree-add! tree 0 4)
   (check-true (btree? (tree-add tree 10)))
   (check-exn exn:fail:contract? (λ () (tree-add tree 1)))))
