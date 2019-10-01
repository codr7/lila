(in-package lila)

(define-symbol-macro *args* (get-val (make-id "ARGS")))
(define-symbol-macro *stdin* (get-val (make-id "stdin")))
(define-symbol-macro *stdout* (get-val (make-id "stdout")))

(defun lila-load (filename)
  (with-open-file (in filename)
    (let ((*pos* (new-pos :file filename)))
      (lila-compile (read-vals in)))))

(defmethod dump-val (v out)
  (print-object v out))
