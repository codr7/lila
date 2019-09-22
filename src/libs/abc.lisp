(in-package lila)

(defun init-abc ()
  (let-id any-type)
  (let-id meta-type)

  (let-id _-type)
  (let-id $-type)
  
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
    (format t "clock: ~a ~a~%" reps expr)

    `(let ((start (get-internal-run-time)))
       ,@(emit-val reps :pos pos)
       (dotimes (-- (pop-val))
         ,@(emit-vals (body expr)))
       (push-val (floor (- (get-internal-run-time) start)
                        (floor internal-time-units-per-second 1000)))))
            
  (let-macro const (pos out id val)
    (format t "const: ~a ~a~%" id val)
    (cons (make-const-op pos id val) out))

  (let-fun dump (pos val)
    (dump-val val *stdout*)))
