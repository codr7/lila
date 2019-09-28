(in-package lila)

(define-type pair (any))
(define-type list (any))

(defmethod emit-val ((lst list) &key in out (pos *pos*))
  (values (cons (if (pair? lst)
                    `(cons ,(first (emit-val (first lst) :pos pos))
                           ,(first (emit-val (rest lst) :pos pos)))
                    `(list ,@(mapcar (lambda (v)
                                       (first (emit-val v :pos pos)))
                                     lst)))
                out)
          in))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defmethod to-bool ((v list))
  (or (pair? v) (> (length v) 0)))
