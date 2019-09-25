(in-package lila)

(defclass do-op (op)
  ((body :initform nil :initarg :body :reader body)
   (ops :initform nil :initarg :ops :reader ops)
   (code :initform nil :initarg :code :reader code)))

(defun make-do-op (pos &rest args)
  (apply #'make-instance 'do-op :pos (clone pos) args))

(defmethod compile-op ((op do-op) in out)
  (with-slots (body ops) op
    (when body
      (setf ops
            (with-env ((clone-env))
              (compile-ops (compile-vals body))))))
  (values in (cons op out)))

(defmethod emit-op ((op do-op) out)
  (with-slots (ops code) op
    (cons (or code `(progn ,@(emit-ops ops))) out)))

(defmethod print-object ((op do-op) out)
  (format out "DO(~a)" (body op)))
