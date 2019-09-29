(in-package lila)

(defun init-abc ()
  (let-id none-type)
  (let-type any-type)
  (let-type meta-type)

  (let-type bool-type)
  (let-type expr-type)
  (let-type false-type)
  (let-type fun-type)
  (let-type int-type)
  (let-type macro-type)
  (let-type list-type)
  (let-type pair-type)
  (let-type sym-type)
  (let-type true-type)

  (let-fun < (pos x y)
    (make-bool (eq (compare-vals x y) :lt)))

  (let-fun > (pos x y)
    (make-bool (eq (compare-vals x y) :gt)))

  (let-macro clock (pos out reps expr)
    (cons `(clock ,(first (emit-val reps :pos pos))
             ,@(emit-vals (body expr)))
          out))
              
  (let-macro const (pos out id val)
    (let-val id val :pos pos)
    out)
  
  (let-fun dump (pos val)
    (dump-val val *stdout*)
    (terpri *stdout*))

  (let-macro fun (pos out id args expr)
    (when (eq (get-val id :default _) _)
      (let-id (make-instance 'fun
                             :id id 
                             :nargs (length args)
                             :imp (ensure-generic-function (lisp-id id)))))

    (with-env ((clone-env))
      (dolist (a args)
        (let-val (make-id (symbol-name (get-arg-id a)))
                 (make-undef)
                 :pos pos))
      
      (let ((fargs (mapcar (lambda (a)
                             (if (and (consp a) (pair? a))
                                 (cons (lisp-id (first a)) (rest a))
                                 (lisp-id a)))
                           args)))
        (cons `(let-fun ,id ,(cons 'pos fargs)
                 ,@(emit-vals (body expr)))
              out))))

  (let-macro if (pos out cond x y)
    (cons `(if (to-bool ,(first (emit-val cond :pos pos)))
               ,(unless (eq x _) (first (emit-val x :pos pos)))
               ,(unless (eq y _) (first (emit-val y :pos pos))))
          out))

  (let-fun is (pos x y)
    (make-bool (eq x y)))

  (let-fun is-a (pos child parent)
    (make-bool (is-a child parent)))

  (let-fun type-of (pos (v any-opt))
    (get-type v))
  
  (let-macro var (pos out id val)
    (let ((p (gensym)) (x (gensym)) (y (gensym)))
      (labels ((let-vals (id var)
                 (if (pair? id)
                     `(let ((,x (first ,var))
                            (,y (rest ,var)))
                        ,(let-vals (first id) x)
                        ,(let-vals (rest id) y))
                     (progn
                       (let-val id (make-undef) :pos pos)
                       `(setf ,(lisp-id id) ,var)))))
        (if (pair? id)
            (cons `(let ((,p ,(first (emit-val val :pos pos))))
                     ,(let-vals id p))
                  out)
            (progn
              (let-val id (make-undef) :pos pos)
              (cons `(setf ,(lisp-id id) ,(first (emit-val val :pos pos))) out)))))))

(defmacro with-lila (&body body)
  `(with-env ()
     (init-abc)
       ,@body))
