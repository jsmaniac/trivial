#lang typed/racket/base
(provide (rename-out
  (define-vector:            define-vector)
  (let-vector:               let-vector)
  (vector-length:            vector-length)
  (vector-ref:               vector-ref)
  (vector-set!:              vector-set!)
  (vector-map:               vector-map)
  (vector-map!:              vector-map!)
  (vector-append:            vector-append)
  (vector->list:             vector->list)
  (vector->immutable-vector: vector->immutable-vector)
  (vector-fill!:             vector-fill!)
  (vector-take:              vector-take)
  (vector-take-right:        vector-take-right)
  (vector-drop:              vector-drop)
  (vector-drop-right:        vector-drop-right)
))
(require trivial/vector)
