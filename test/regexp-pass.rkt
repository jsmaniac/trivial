#lang typed/racket/base

(module+ test

  (require
    trivial/regexp
    typed/rackunit)

  ;; -- regexp-match:
  (check-equal?
    (ann
      (regexp-match: "hello" "hello world")
      (U #f (List String)))
    '("hello"))

  (check-equal?
    (ann
      (regexp-match: "hello" "world")
      (U #f (List String)))
    #f)

  (check-equal?
    (ann
      (regexp-match: "he(l*)o" "hellllloooo")
      (U #f (List String String)))
    '("helllllo" "lllll"))

  (check-equal?
    (ann
      (regexp-match: #rx"he(l*)o" "helllooo")
      (U #f (List String String)))
    '("helllo" "lll"))

  (check-equal?
    (ann
      (regexp-match: #rx"h(e(l*))(o)" "helllooo")
      (U #f (List String String String String)))
    '("helllo" "elll" "lll" "o"))

  (check-equal?
    (ann
      (regexp-match: #px"h(e(l*))(o)" "helllooo")
      (U #f (List String String String String)))
    '("helllo" "elll" "lll" "o"))

  (check-equal?
    (ann
      (regexp-match: #rx#"h(e(l*))(o)" "helllooo")
      (U #f (List Bytes Bytes Bytes Bytes)))
    '(#"helllo" #"elll" #"lll" #"o"))

  (check-equal?
    (ann
      (regexp-match: #px#"h(e(l*))(o)" "helllooo")
      (U #f (List Bytes Bytes Bytes Bytes)))
    '(#"helllo" #"elll" #"lll" #"o"))

  ;; -- higher-order
  ;; --- regexp-match:
  (check-equal?
    ((lambda ([f : (-> String String (U #f (Listof (U #f String))))])
      (f "hi" "ahi tuna"))
     regexp-match:)
    '("hi"))

  (check-exn exn:fail:contract?
    (lambda ()
      ((lambda ([f : (-> String String Any)])
         (f "ah(oy" "ahoy"))
       regexp-match:)))

  ;; --- regexp:
  (check-equal?
    ((lambda ([f : (-> String Regexp)])
      (f "aloha"))
     regexp:)
    (regexp "aloha"))

  (check-exn exn:fail:contract?
    (lambda ()
      ((lambda ([f : (-> String Regexp)])
         (f "ah(oy"))
       regexp:)))

  ;; --- pregexp:
  (check-equal?
    ((lambda ([f : (-> String PRegexp)])
      (f "aloha"))
     pregexp:)
    (pregexp "aloha"))

  (check-exn exn:fail:contract?
    (lambda ()
      ((lambda ([f : (-> String PRegexp)])
         (f "ah(oy"))
       pregexp:)))

  ;; --- byte-regexp:
  (check-true ;;bg; bug in 6.3
    (equal?
      ((lambda ([f : (-> Bytes Byte-Regexp)])
         (f #"aloha"))
        byte-regexp:)
      (byte-regexp #"aloha")))

  (check-exn exn:fail:contract?
    (lambda ()
      ((lambda ([f : (-> Bytes Byte-Regexp)])
         (f #"ah(oy"))
       byte-regexp:)))

  ;; --- byte-pregexp:
  (check-true
    (equal?
      ((lambda ([f : (-> Bytes Byte-PRegexp)])
         (f #"aloha"))
       byte-pregexp:)
      (byte-pregexp #"aloha")))

  (check-exn exn:fail:contract?
    (lambda ()
      ((lambda ([f : (-> Bytes Byte-PRegexp)])
         (f #"ah(oy"))
       byte-pregexp:)))

  ;; -- define-regexp:
  (check-equal?
    (ann
      (let ()
        (define-regexp: rx "\\(\\)he(l*)(o*)")
        (regexp-match: rx "helllooo"))
      (U #f (List String String String)))
    #f)

  (check-equal?
    (ann
      (let ()
        (define-regexp: rx #rx"he(l*)(o*)")
        (regexp-match: rx "helllooo"))
      (U #f (List String String String)))
    '("helllooo" "lll" "ooo"))

  (check-equal?
    (ann
      (let ()
        (define-regexp: rx #rx"h(?=e)(l*)(o*)")
        (regexp-match: rx "hello"))
      (U #f (List String String String)))
    '("h" "" ""))

  (check-equal?
    (ann
      (let ()
        (regexp-match: (regexp: "he(l*)(o*)") "hellooo"))
      (U #f (List String String String)))
    '("hellooo" "ll" "ooo"))

  (check-equal?
    (ann
      (let ()
        (define-regexp: rx (regexp "he(l*)(o*)"))
        (regexp-match: rx "hellooo"))
      (U #f (Listof (U #f String))))
    '("hellooo" "ll" "ooo"))

  ;; -- define-pregexp:
  (check-equal?
    (ann
      (let ()
        (define-pregexp: rx #px"he(l*)(o*)")
        (regexp-match: rx "helllooo"))
      (U #f (List String String String)))
    '("helllooo" "lll" "ooo"))

  (check-equal?
    (ann
      (let ()
        (regexp-match: (pregexp: "he(l*)(o*)") "hellooo"))
      (U #f (List String String String)))
    '("hellooo" "ll" "ooo"))

  (check-equal?
    (ann
      (let ()
        (define-pregexp: rx (pregexp: "he(l*)(o*)"))
        (regexp-match: rx "hellooo"))
      (U #f (List String String String)))
    '("hellooo" "ll" "ooo"))

  ;; -- define-byte-regexp:
  (check-equal?
    (ann
      (regexp-match: #rx#"he(l*)(o*)" #"helllooo")
      (U #f (List Bytes Bytes Bytes)))
    '(#"helllooo" #"lll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (define-byte-regexp: rx #rx#"he(l*)(o*)")
        (regexp-match: rx #"helllooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"helllooo" #"lll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (regexp-match: (byte-regexp: #"he(l*)(o*)") "hellooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"hellooo" #"ll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (define-byte-regexp: rx (byte-regexp: #"he(l*)(o*)"))
        (regexp-match: rx "hellooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"hellooo" #"ll" #"ooo"))

  ;; -- define-byte-pregexp:
  (check-equal?
    (ann
      (regexp-match: #px#"he(l*)(o*)" "helllooo")
      (U #f (List Bytes Bytes Bytes)))
    '(#"helllooo" #"lll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (define-byte-pregexp: rx #px#"he(l*)(o*)")
        (regexp-match: rx "helllooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"helllooo" #"lll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (regexp-match: (byte-pregexp: #"he(l*)(o*)") "hellooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"hellooo" #"ll" #"ooo"))

  (check-equal?
    (ann
      (let ()
        (define-byte-pregexp: rx (byte-pregexp: #"he(l*)(o*)"))
        (regexp-match: rx "hellooo"))
      (U #f (List Bytes Bytes Bytes)))
    '(#"hellooo" #"ll" #"ooo"))

)