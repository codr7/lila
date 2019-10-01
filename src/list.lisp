(in-package lila)

(define-type pair (any))
(define-type list (pair))

(defmethod dump-val ((v list) out)
  (cond
    ((pair? v)
     (print-object (first v) out)
     (write-char #\: out)
     (print-object (rest v) out))
    (t (call-next-method))))

(defmethod emit-val ((v list) &key in out (pos *pos*))
  (values (cons (if (pair? v)
                    `(cons ,(first (emit-val (first v) :pos pos))
                           ,(first (emit-val (rest v) :pos pos)))
                    `(list ,@(mapcar (lambda (v)
                                       (first (emit-val v :pos pos)))
                                     v)))
                out)
          in))

(defmethod equal-vals ((x list) (y list))
  (labels ((rec (x y)
             (cond
               ((and x y)
                (when (equal-vals (first x) (first y))
                    (equal-vals (rest x) (rest y))))
               (t
                (not (or x y))))))
    (rec x y)))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defclass empty-list ()
  ())

(defvar *empty-list* (make-instance 'empty-list))

(defmethod dump-val ((v empty-list) out)
  (write-string "()" out))

(defmethod get-type ((v empty-list))
  list-type)

(defmethod to-bool ((v empty-list))
  t)

(defun to-list (in)
  (unless (eq in *empty-list*)
    in))

(defun make-lila-list (in)
  (or in *empty-list*))
