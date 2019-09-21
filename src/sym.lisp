(in-package lila)

(define-type sym (find-class 'symbol))

(defmethod compile-val ((id symbol) in out &key (pos *pos*))
  (let* ((v (get-val id :pos pos :default _))
         (vt (get-type v)))
    (cond
      ((eq v _)
       (values in (cons (make-get-op pos id) out)))
      ((eq vt fun-type)
       (with-slots (nargs) v
         (if (zerop nargs)
             (values in (cons (make-call-op pos v) out))
             (multiple-value-bind (args in) (split in nargs)
               (values in (cons (make-call-op pos v)
                                (compile-vals args :out out :reverse? nil)))))))
      ((eq vt macro-type)
       (expand v in out :pos pos))
      (t
       (values in (cons (make-push-op pos v) out))))))

(defmethod get-type ((-- symbol)) sym-type)
  
