(in-package lila)

(define-type sym (any))

(defmethod compare-vals ((x symbol) (y symbol))
  (let ((xn (symbol-name x)) (yn (symbol-name y)))
    (cond
      ((string< xn yn) :lt)
      ((string= xn yn) :eq)
      (t :gt))))

(defmethod compile-val ((id symbol) in out &key (pos *pos*))
  (let* ((v (get-val id :pos pos :default _))
         (vt (get-type v)))
    (cond
      ((or (eq v _) (undef? v))
       (values in (cons (make-get-op pos id) out)))
      ((eq vt fun-type)
       (with-slots (nargs) v
         (multiple-value-bind (args in) (split in nargs)
           (values in (cons (make-call-op pos v)
                            (compile-vals args :out out :reverse? nil))))))
      ((is-a? vt macro-type)
       (expand v in out :pos pos))
      (t
       (values in (cons (make-push-op pos v) out))))))

(defmethod emit-val ((id symbol) &key (pos *pos*))
  (let ((v (get-val id :pos pos :default _)))
    (if (or (eq v _) (undef? v)) (lisp-id id) (emit-val v :pos pos))))

(defmethod get-type ((-- symbol)) sym-type)
  
