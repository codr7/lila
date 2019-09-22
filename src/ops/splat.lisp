(in-package lila)

(defclass splat-op (op)
  ((val :initarg :val :reader val)))

(defun make-splat-op (pos val &rest args)
  (apply #'make-instance 'splat-op :pos (clone pos) :val val args))

(defmethod emit-op ((op splat-op) out)
  (with-slots (pos val) op
    (cons `(splat-val ,(emit-val val :pos pos)) out)))

(defmethod print-object ((op splat-op) out)
  (format out "SPLAT(~a)" (val op)))
