(in-package lila)

(defclass emit-op (op)
  ((imp :initarg :imp :reader imp)
   (args :initarg :args :reader args)))

(defun make-emit-op (pos imp args)
  (make-instance 'emit-op :pos (clone pos) :imp imp :args args))

(defmethod emit-op ((op emit-op) out)
  (with-slots (imp args) op
    (cons (apply imp args) out)))

(defmethod print-object ((op emit-op) out)
  (with-slots (imp args) op
    (format out "EMIT(~a ~a)" imp args)))
