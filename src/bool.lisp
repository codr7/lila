(in-package lila)

(defclass bool () ())

(define-type bool (find-class 'bool))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(define-type true (find-class 'true))

(defmethod get-type ((-- true)) true-type)

(defmethod to-bool (--) t)


(defclass false (bool) ())

(defvar false (make-instance 'false))

(define-type false (find-class 'false))

(defmethod get-type ((-- false)) false-type)

(defmethod to-bool ((-- false)) nil)
