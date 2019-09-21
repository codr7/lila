(in-package lila)

(defclass expr ()
  ((body :initform nil :initarg :body :reader body)
   (body-ops :initform nil :initarg :body-ops)))

(define-type expr (find-class 'expr))

(defun make-expr (&rest args)
  (apply #'make-instance 'expr args))

(defmethod compile-body ((e expr))
  (with-slots (body body-ops) e
    (unless body-ops
      (setf body-ops (compile-vals body :out body-ops)))))
  
(defmethod compile-val ((e expr) in out &key (pos *pos*))
  (compile-body e)
  (values in (cons (make-push-op pos e) out)))

(defmethod get-type ((-- expr)) expr-type)

(defmethod print-object ((e expr) out)
  (print-object (body e) out))


