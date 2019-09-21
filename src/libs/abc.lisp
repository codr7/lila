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
  (let-id list-type)
  (let-id pair-type)
  (let-id sym-type)
  (let-id true-type)
  
  (let-macro const (pos out id val)
    (format t "const: ~a ~a~%" id val)
    (cons (make-const-op pos id val) out))

  (let-macro do (pos out expr)
    (format t "do: ~a~%" expr)
    (let ((compile-body expr nil nil :pos pos)))
    (let (body)
      (compile-ops (body expr) :out body))
    (cons `(progn ,@body) out)))
