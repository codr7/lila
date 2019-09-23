(in-package lila)

(defclass bool ()
  ())

(define-type bool (any))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(define-type true (bool))

(defmethod get-type ((-- true))
  true-type)

(defmethod to-bool (--)
  t)


(defclass false (bool)
  ())

(defvar false (make-instance 'false))

(define-type false (bool))

(defmethod get-type ((-- false))
  false-type)

(defmethod to-bool ((-- false))
  nil)
