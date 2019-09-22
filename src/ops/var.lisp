(in-package lila)

(defclass var-op (op)
  ((id :initarg :id)
   (val :initarg :val)))

(defun make-var-op (pos id &rest args)
  (apply #'make-instance 'var-op :pos (clone pos) :id id args))

(defmethod compile-op ((op var-op) in out)
  (labels ((let-vals (pos id val)
             (if (pair? id)
                 (let ((fst (first id))
                       (snd (rest id)))
                   (push (make-splat-op pos val) out)
                   (let-vals pos snd $)
                   (let-vals pos fst $))
                 (progn
                   (let-val id (make-undef) :pos pos)
                   (push (make-var-op pos id) out)))))
    (with-slots (pos id val) op
      (if (pair? id)
          (progn
            (let-vals pos id (if (slot-boundp op 'val) val $)))
          (progn
            (let-val id (make-undef) :pos pos)
            (push op out)))
      (values in out))))

(defmethod emit-op ((op var-op) out)
  (with-slots (pos id val) op
    (cons `(setf ,(lisp-id id)
                 ,(if (slot-boundp op 'val)
                      `(emit-val val :pos pos)
                      `(pop-val)))
          out)))

(defmethod print-object ((op var-op) out)
  (with-slots (id val) op
    (format out "VAR(~a ~a)" id val)))
