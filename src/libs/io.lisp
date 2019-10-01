(in-package lila)

(defun init-io-vars ()
  (let-val (make-id "ARGS") sb-ext:*posix-argv* :force? t)
  (let-val (make-id "stdin") *standard-input* :force? t)
  (let-val (make-id "stdout") *standard-output* :force? t))

(defun init-io ()
  (init-io-vars)

  (let-macro with-str (pos out (var sym) (body expr))
    (cons `(with-output-to-string (,(lisp-id var))
             ,@(emit-vals (vals body)))
          out)))

