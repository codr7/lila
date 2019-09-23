(in-package lila)

(defclass expr ()
  ((body :initform nil :initarg :body :reader body)))

(define-type expr (any))

(defun make-expr (&rest args)
  (apply #'make-instance 'expr args))

(defmethod compile-val ((e expr) in out &key (pos *pos*))
  (values in (cons (make-do-op pos :body (body e)) out)))

(defmethod get-type ((-- expr))
  expr-type)

(defmethod print-object ((e expr) out)
  (print-object (body e) out))
