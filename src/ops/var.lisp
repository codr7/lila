(in-package lila)

(defclass var-op (op)
  ((id :initarg :id)
   (val :initarg :val)))

(defun make-var-op (pos id &rest args)
  (apply #'make-instance 'var-op :pos (clone pos) :id id args))

(defmethod compile-op ((op var-op) in out)
  (with-slots (pos id) op
    (let-val id (make-undef) :pos pos)
    (values in (cons op out))))

(defmethod emit-op ((op var-op) out)
  (with-slots (pos id val) op
    (when (slot-boundp op 'val)
      (push (emit-val val :pos pos) out))
    (cons `(setf ,(lisp-id id) (pop-val)) out)))

(defmethod print-object ((op var-op) out)
  (with-slots (id val) op
    (format out "VAR(~a ~a)" id val)))
