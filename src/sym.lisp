(in-package lila)

(define-type sym (find-class 'symbol))

(defmethod compile-val ((id symbol) in out &key (pos *pos*))
  (let ((v (get-val id :pos pos)))
    (if (eq (get-type v) macro-type)
        (expand v in out :pos pos)
        (values in (cons (make-push-op pos v) out)))))

(defmethod get-type ((-- symbol)) sym-type)
  
