(in-package lila)

(defclass push-op (op)
  ((val :initarg :val :reader val)))

(defun make-push-op (pos val &rest args)
  (apply #'make-instance 'push-op :pos (clone pos) :val val args))

(defmethod emit-op ((op push-op) out)
  (with-slots (pos val) op
    (cons `(push-val ,(emit-val val :pos pos)) out)))

(defmethod print-object ((op push-op) out)
  (format out "PUSH(~a)" (val op)))
