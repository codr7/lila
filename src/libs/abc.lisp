(in-package lila)

(defun init-abc ()
  (let-id none-type)
  (let-type any-type)
  (let-type meta-type)
  (let-type pop-type)

  (let-type macro-type)
  (let-type lisp-macro-type)

  (let-type bool-type)
  (let-type expr-type)
  (let-type false-type)
  (let-type int-type)
  (let-type list-type)
  (let-type pair-type)
  (let-type sym-type)
  (let-type true-type)

  (let-fun < (pos x y)
    (push-val (make-bool (eq (compare-vals x y) :lt))))

  (let-fun > (pos x y)
    (push-val (make-bool (eq (compare-vals x y) :gt))))

  (let-lisp-macro clock (pos reps expr)
    `(push-val (clock ,(emit-val reps :pos pos)
                 ,@(emit-vals (body expr)))))
              
  (let-macro const (pos out id val)
    (cons (make-const-op pos id val) out))

  (let-fun dump (pos val)
    (dump-val val *stdout*)
    (terpri *stdout*))

  (let-fun is (pos x y)
    (push-val (make-bool (eq x y))))

  (let-macro pop (pos out)
    (cons (make-pop-op pos) out))

  (let-macro var (pos out id val)
    (cons (make-var-op pos id :val val) out)))

(defmacro with-lila (&body body)
  `(with-env ()
     (init-abc)
     (with-stack ()
       ,@body)))
