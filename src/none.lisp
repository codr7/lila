(in-package lila)

(defclass _ ()
  ())

(defvar _ (make-instance '_))

(define-type none ())

(defmethod get-type ((-- _))
  none-type)

(defmethod print-object ((-- _) out)
  (write-char #\_ out))
