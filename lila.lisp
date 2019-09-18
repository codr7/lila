(defpackage lila
  (:use :cl)
  (:export lila-version))

(in-package lila)

(define-symbol-macro lila-version
    `(slot-value (asdf:find-system 'lila) 'asdf:version))
