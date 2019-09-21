(in-package lila)

(defclass do-op (op)
  ((body :initarg :body :reader body)
   (body-ops :initarg :body-ops :reader body-ops)))

(defun make-do-op (pos body &rest args)
  (apply #'make-instance 'do-op :pos (clone pos) :body body args))

(defmethod compile-op ((op do-op) in out)
  (with-slots (body body-ops) op
    (setf body-ops
          (with-env ((clone *env*))
            (compile-ops (compile-vals body)))))
  (values in (cons op out)))

(defmethod emit-op ((op do-op) out)
  (cons `(progn ,@(emit-ops (body-ops op))) out))

(defmethod print-object ((op do-op) out)
  (format out "DO(~a)" (body-ops op)))
