(in-package lila)

(defun init-abc ()
  (let-id any-type)
  (let-id meta-type)

  (let-id none-type)
  (let-id pop-type)
  
  (let-id bool-type)
  (let-id expr-type)
  (let-id false-type)
  (let-id int-type)
  (let-id lisp-macro-type)
  (let-id list-type)
  (let-id macro-type)
  (let-id pair-type)
  (let-id sym-type)
  (let-id true-type)

  (let-lisp-macro clock (pos reps expr)
    `(push-val (clock ,(emit-val reps :pos pos)
                 ,@(emit-vals (body expr)))))
              
  (let-macro const (pos out id val)
    (cons (make-const-op pos id val) out))

  (let-fun dump (pos val)
    (dump-val val *stdout*))

  (let-macro var (pos out id val)
    (cons (make-var-op pos id :val val) out)))

(defmacro with-lila (&body body)
  `(with-env ()
     (init-abc)
     (with-stack ()
       ,@body)))
