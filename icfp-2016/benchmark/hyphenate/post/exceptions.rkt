#lang typed/racket/base
(require trivial/no-colon)

(provide default-exceptions)

;; Knuth and Liang's original exception patterns from classic TeX.
;; In the public domain.
(: default-exceptions (Listof Symbol))
(define default-exceptions '(as-so-ciate as-so-ciates dec-li-na-tion oblig-a-tory phil-an-thropic present presents project projects reci-procity re-cog-ni-zance ref-or-ma-tion ret-ri-bu-tion ta-ble))