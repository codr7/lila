(in-package lila)

(defclass bool () ())

(define-type bool (find-class 'bool) (any-type))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(define-type true (find-class 'true) (bool-type))

(defmethod get-type ((-- true)) true-type)

(defmethod to-bool (--) t)


(defclass false (bool) ())

(defvar false (make-instance 'false))

(define-type false (find-class 'false) (bool-type))

(defmethod get-type ((-- false)) false-type)

(defmethod to-bool ((-- false)) nil)
