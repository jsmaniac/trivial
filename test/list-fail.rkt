#lang racket/base
(require trivial/private/test-common)

;; TODO
;; - fix test (list-ref: (list-ref: ...) ...)

(module+ test (test-compile-error
  #:require trivial/list trivial/math
  #:exn #rx"out-of-bounds|Type Checker"

  (car: '())
  (cdr: '())

  (list-ref: (list 1) 3)

  (let-list: ([v (list 1 2 3)])
    (list-ref: v 3))

  (let ()
    (define-list: v (list 3 4))
    (list-ref: v 9))

  ;; TODO
  ;(let-list: ([v1  (list 1)])
  ;  (let-list: ([v2 (list v1)])
  ;    (list-ref: (list-ref: v2 0) 1)))

  ;(list-ref: (map: (lambda (x) x) (list #t "ha")) 20)

  (list-ref: (list 0) -5)

  ;(list-ref:
  ; (map: add1 (map: add1 (map: add1 (list 0 0 0))))
  ; 3)

  ;(list-ref: (map: symbol->string (list 'a 'b)) 5)

  ;(list-ref:
  ;  (map: add1 (map: add1 (map: add1 (list 0 0 0))))
  ;  3)

  (let-list: ([v (list 0 0 0)]
                [v2 (list 1 2)])
    (list-ref: (append: v2 v) 8))

  (list-ref: (list 1 2 1) 3)
))