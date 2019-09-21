(in-package lila)

(defclass call-op (op)
  ((fun :initarg :fun :reader fun)))

(defun make-call-op (pos fun &rest args)
  (apply #'make-instance 'call-op :pos (clone pos) :fun fun args))

(defmethod emit-op ((op call-op) out)
  (with-slots (pos fun) op
    (cons `(call ,fun :pos ,pos) out)))

(defmethod print-object ((op call-op) out)
  (format out "CALL(~a)" (fun op)))
