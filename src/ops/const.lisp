(in-package lila)

(defclass const-op (op)
  ((id :initarg :id)
   (val :initarg :val)))

(defun make-const-op (pos id val &rest args)
  (apply #'make-instance 'const-op :pos (clone pos) :id id :val val args))

(defmethod compile-op ((op const-op) in out)
  (with-slots (pos id val) op
    (let-val id val :pos pos)
    (values in (cons op out))))
