(in-package lila)

(define-type sym (any))

(defmethod compile-val ((id symbol) in out &key (pos *pos*))
  (let* ((v (get-val id :pos pos :default _))
         (vt (get-type v)))
    (cond
      ((eq v _)
       (values in (cons (make-get-op pos id) out)))
      ((eq vt fun-type)
       (with-slots (nargs) v
         (multiple-value-bind (args in) (split in nargs)
           (values in (cons (make-call-op pos v)
                            (compile-vals args :out out :reverse? nil))))))
      ((subtype? vt macro-type)
       (expand v in out :pos pos))
      (t
       (values in (cons (make-push-op pos v) out))))))

(defmethod emit-val ((id symbol) &key (pos *pos*))
  (let ((v (get-val id :pos pos :default _)))
    (if (eq v _) `(get-val ',id :pos ,pos) (emit-val v :pos pos))))

(defmethod get-type ((-- symbol)) sym-type)
  
