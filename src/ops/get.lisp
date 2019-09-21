(in-package lila)

(defclass get-op (op)
  ((id :initarg :id :reader id)))

(defun make-get-op (pos id &rest args)
  (apply #'make-instance 'get-op :pos (clone pos) :id id args))

(defmethod compile-op ((op get-op) in out)
  (with-slots (pos id) op
    (let ((v (get-val id :default _)))
      (values in (cons (if (eq v _)
                           op
                           (make-push-op pos v))
                       out)))))

(defmethod emit-op ((op get-op) out)
  (with-slots (pos id) op
    (cons `(get-val ',id :pos ,pos) out)))

(defmethod print-object ((op get-op) out)
  (format out "GET(~a)" (id op)))
