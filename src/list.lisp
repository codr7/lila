(in-package lila)

(define-type pair (any))
(define-type list (any))

(defmethod emit-val ((lst list) &key (pos *pos*))
  (if (pair? lst)
      `(cons ,(emit-val (first lst) :pos pos) ,(emit-val (rest lst) :pos pos))
      `(list ,@(mapcar (lambda (v) (emit-val v :pos pos)) lst))))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defmethod to-bool ((v list))
  (or (pair? v) (> (length v) 0)))

(defmethod splat-val ((lst list))
  (cond
    ((pair? lst)
     (push-val (first lst))
     (push-val (rest lst)))
    (t (dolist (v lst)
         (push-val v)))))
