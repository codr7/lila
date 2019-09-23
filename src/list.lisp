(in-package lila)

(define-type pair (any))
(define-type list (any))

(defmethod emit-val ((lst list) &key (pos *pos*))
  (declare (ignore pos))
  (if (pair? lst)
      `(cons ,(emit-val (first lst)) ,(emit-val (rest lst)))
      `(list ,@(mapcar (lambda (v) (emit-val v)) lst))))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defmethod to-bool ((v list))
  (or (pair? v) (> (length v) 0)))

(defmethod splat-val ((lst list))
  (if (pair? lst)
      (progn
        (push-val (first lst))
        (push-val (rest lst)))
      (dolist (v lst)
        (push-val v))))
