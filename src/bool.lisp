(in-package lila)

(defclass bool () ())

(define-type bool (find-class 'bool) (any-type))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(define-type true (find-class 'true) (bool-type))

(defmethod get-type ((val true)) true-type)

(defmethod to-bool ((val true)) t)


(defclass false (bool) ())

(defvar false (make-instance 'false))

(define-type false (find-class 'false) (bool-type))

(defmethod get-type ((val false)) false-type)

(defmethod to-bool ((val false)) nil)
