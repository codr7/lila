(in-package lila)

(define-type "Stream" (any))
(define-type "InStream" (stream))
(define-type "OutStream" (stream))
(define-type "InStr" (in-stream))
(define-type "OutStr" (out-stream))

(define-symbol-macro in-str (find-class 'character-string-istream))
(define-symbol-macro out-str (find-class 'character-string-ostream))

(defun init-io-vars ()
  (let-val (make-id "ARGS") sb-ext:*posix-argv* :force? t)
  (let-val (make-id "stdin") *standard-input* :force? t)
  (let-val (make-id "stdout") *standard-output* :force? t))

(defun init-io ()
  (init-io-vars)

  (let-type stream-type)
  (let-type in-stream-type)
  (let-type out-stream-type)
  (let-type in-str-type)
  (let-type out-str-type)

  (let-fun dump (pos (val any?))
    (dump-val val *stdout*)
    (terpri *stdout*))

  (let-macro with-out-str (pos out (var sym) (body expr))
    (cons `(with-output-to-string (,(lisp-id var))
             ,@(emit-vals (vals body)))
          out)))
