(in-package lila)

(defclass do-op (op)
  ((body :initform nil :initarg :body :reader body)
   (body-ops :initform nil :initarg :body-ops :reader body-ops)
   (body-src :initform nil :initarg :body-src :reader body-src)))

(defun make-do-op (pos &rest args)
  (apply #'make-instance 'do-op :pos (clone pos) args))

(defmethod compile-op ((op do-op) in out)
  (with-slots (body body-ops) op
    (when body
      (setf body-ops
            (with-env ((clone *env*))
              (compile-ops (compile-vals body))))))
  (values in (cons op out)))

(defmethod emit-op ((op do-op) out)
  (with-slots (body-ops body-src) op
    (cons (or body-src `(progn ,@(emit-ops body-ops))) out)))

(defmethod print-object ((op do-op) out)
  (format out "DO(~a)" (body op)))
