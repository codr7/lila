(in-package lila)

(defclass pop-op (op)
  ((n :initform 1 :initarg :n :reader n)))

(defun make-pop-op (pos &rest args)
  (apply #'make-instance 'pop-op :pos (clone pos) args))

(defmethod emit-op ((op pop-op) out)
  (with-slots (pos n) op
    (cons `(decf (fill-pointer (items *stack*)) ,n) out)))

(defmethod print-object ((op pop-op) out)
  (format out "POP(~a)" (n op)))
