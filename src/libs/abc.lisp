(in-package lila)

(defvar *let-fun-id* _)

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

  (let-val (make-id "true") true)
  (let-val (make-id "false") false)
  
  (let-fun < (pos x y)
    (make-bool (eq (compare-vals x y) :lt)))

  (let-fun > (pos x y)
    (make-bool (eq (compare-vals x y) :gt)))

  (let-macro and (pos out x y)
    (cons `(and ,(first (emit-val x :pos pos))
                ,(first (emit-val y :pos pos)))
          out))

  (let-fun bool (pos (val any?))
    (to-bool val))

  (let-macro check (pos out (op none) (body expr))
    (cons `(to-bool ,(first (emit-val body :pos pos))) out))

  (let-macro check (pos out (op sym) (args list))
    (cons `(call ,(get-val op :pos pos)
                 (list ,@(mapcar (lambda (v)
                                   (first (emit-val v :pos pos)))
                                 args))
                 :pos ,pos)
          out))

  (let-macro clock (pos out reps (body expr))
    (cons `(clock ,(first (emit-val reps :pos pos))
             ,@(emit-vals (vals body)))
          out))
              
  (let-macro const (pos out id val)
    (let-val id val :pos pos)
    out)
  
  (let-fun dump (pos (val any?))
    (dump-val val *stdout*)
    (terpri *stdout*))

  (let-macro fun (pos out (id sym) (args list) (body expr))
    (setf args (to-list args))
    
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
        (let ((*let-fun-id* (lisp-id id)))
          (cons `(let-fun ,id ,(cons 'pos fargs)
                   ,@(emit-vals (vals body)))
                out)))))

  (let-macro if (pos out cond x y)
    (cons `(if (to-bool ,(first (emit-val cond :pos pos)))
               ,(unless (eq x _) (first (emit-val x :pos pos)))
               ,(unless (eq y _) (first (emit-val y :pos pos))))
          out))

  (let-fun is (pos x y)
    (make-bool (eq x y)))

  (let-fun is-a (pos (child meta) (parent meta))
    (make-bool (is-a child parent)))

  (let-macro not (pos out val)
    (cons `(make-bool (not (to-bool ,(first (emit-val val :pos pos))))) out))
  
  (let-macro or (pos out x y)
    (cons `(or ,(first (emit-val x :pos pos))
                ,(first (emit-val y :pos pos)))
          out))

  (let-macro recall (pos out (f Fun?) args)
    (cons `(return-from
            ,*let-fun-id*
             (call ,(if (eq f _) '*this-fun* f)
                   ,(first (emit-val args :pos pos))
                   :pos ,pos))
          out))

  (let-macro this-fun (pos out)
    (cons '*this-fun* out))

  (let-fun type-of (pos (v any?))
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
