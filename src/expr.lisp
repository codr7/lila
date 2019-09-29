(in-package lila)

(defclass expr ()
  ((vals :initform nil :initarg :vals :reader vals)))

(define-type expr (any))

(defun make-expr (&rest args)
  (apply #'make-instance 'expr args))

(defmethod emit-val ((e expr) &key in out (pos *pos*))
  (declare (ignore pos))
  (values (cons (get-form (emit-vals (vals e))) out) in))
  
(defmethod get-type ((-- expr))
  expr-type)

(defmethod print-object ((e expr) out)
  (print-object (vals e) out))
