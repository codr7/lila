(in-package lila)

(defclass push-op (op)
  ((val :initarg :val)))

(defun make-push-op (pos val &rest args)
  (apply #'make-instance 'push-op :pos (clone pos) :val val args))

(defmethod compile-op (op out)
  (cons `(push ,(val op) *stack*) out))
