(in-package lila)

(defun init-io ()
  (let-macro with-str (pos out (var sym) (body expr))
    (cons `(with-output-to-string (,(lisp-id var))
             ,@(emit-vals (vals body)))
          out)))

