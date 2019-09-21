(in-package lila)

(defclass push-op (op)
  ((val :initarg :val :reader val)))

(defun make-push-op (pos val &rest args)
  (apply #'make-instance 'push-op :pos (clone pos) :val val args))

(defmethod emit-op ((op push-op) out)
  (cons `(push-val ,(val op)) out))

(defmethod print-object ((op push-op) out)
  (format out "PUSH(~a)" (val op)))
