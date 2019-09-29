(in-package lila)

(define-type pair (any))
(define-type list (any))

(defmethod emit-val ((v list) &key in out (pos *pos*))
  (values (cons (if (pair? v)
                    `(cons ,(first (emit-val (first v) :pos pos))
                           ,(first (emit-val (rest v) :pos pos)))
                    `(list ,@(mapcar (lambda (v)
                                       (first (emit-val v :pos pos)))
                                     v)))
                out)
          in))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defmethod to-bool ((v list))
  (or (pair? v) (not (zerop (length v)))))

(defmethod dump-val ((v list) out)
  (cond
    ((pair? v)
     (print-object (first v) out)
     (write-char #\: out)
     (print-object (rest v) out))
    (t (call-next-method))))
  
