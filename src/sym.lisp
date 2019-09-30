(in-package lila)

(define-type sym (any))

(defmethod compare-vals ((x symbol) (y symbol))
  (let ((xn (symbol-name x)) (yn (symbol-name y)))
    (cond
      ((string< xn yn) :lt)
      ((string= xn yn) :eq)
      (t :gt))))

(defmethod emit-val ((id symbol) &key in out (pos *pos*))
  (let* ((v (get-val id :pos pos :default _))
         (vt (get-type v)))
    (cond
      ((or (eq v _) (undef? v))
       (values (cons (lisp-id id) out) in))
      ((eq vt fun-type)
       (with-slots (nargs) v
         (multiple-value-bind (args in) (split in nargs)
           (values
            (cons `(call ,v (list ,@(mapcan (lambda (a)
                                              (multiple-value-bind (out in2)
                                                  (emit-val (first a)
                                                            :in in
                                                            :pos (rest a))
                                                (setf in in2)
                                                out))
                                            args)) :pos ,pos)
                         out)
                   in))))
      ((is-a vt macro-type)
       (expand v in out :pos pos))
      (t
       (values (cons v out) in)))))

(defmethod get-type ((-- symbol)) sym-type)
