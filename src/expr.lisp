(in-package lila)

(defclass expr ()
  ((body :initform nil :initarg :body :reader body)
   (ops :initform nil :initarg :ops :reader ops)
   (source :initform nil :initarg :source :reader source)))

(define-type expr (find-class 'expr))

(defun make-expr (&rest args)
  (apply #'make-instance 'expr args))

(defmethod compile-body ((e expr))
  (with-slots (body ops source) e
    (unless ops
      (setf ops (compile-ops (compile-vals body))))
    (unless source
      (setf source (emit-ops ops)))))
  
(defmethod compile-val ((e expr) in out &key (pos *pos*))
  (compile-body e)
  (values in (cons (make-push-op pos e) out)))

(defmethod get-type ((-- expr)) expr-type)

(defmethod print-object ((e expr) out)
  (print-object (source e) out))
