(in-package lila)

(defclass _ () ())

(defvar _ (make-instance '_))

(define-type _ (find-class '_) ())

(defmethod get-type ((_ _)) _-type)

(defmethod print-object ((_ _) out)
  (write-char #\_ out))
