(in-package lila)

(defclass bool () ())

(define-type bool (find-class 'bool) (any-type))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(defmethod get-type ((val true)) true-type)

(defmethod to-bool ((val true)) t)

(define-type true (find-class 'true) (bool-type))


(defclass false (bool) ())

(defvar false (make-instance 'false))

(defmethod get-type ((val false)) false-type)

(defmethod to-bool ((val false)) nil)

(define-type false (find-class 'false) (bool-type))
