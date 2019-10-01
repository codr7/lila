(in-package lila)

(defclass bool ()
  ())

(define-type "Bool" (any))


(defclass true (bool) ())

(defvar true (make-instance 'true))

(define-type "True" (bool))

(defmethod get-type ((-- true))
  true-type)

(defmethod print-object ((-- true) out)
  (write-string "true" out))

(defmethod to-bool (--)
  t)


(defclass false (bool)
  ())

(defvar false (make-instance 'false))

(define-type "False" (bool))

(defmethod get-type ((-- false))
  false-type)

(defmethod print-object ((-- false) out)
  (write-string "false" out))

(defmethod to-bool ((-- false)))


(defun make-bool (v)
  (if v true false))
