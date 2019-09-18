(in-package lila)

(define-type any t ())
(define-type meta (find-class 'lila-type) (any-type))
