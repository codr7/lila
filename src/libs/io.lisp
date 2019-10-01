(in-package lila)

(define-type "IO" (any))
(define-type "StrIO" (io))

(defmethod dump-val ((v stream) out)
  (format out "_:~a" (get-type v)))

(defmethod get-type ((-- stream))
  io-type)

(defmethod get-type ((-- string-stream))
  str-io-type)

(defun init-io-vars ()
  (let-val (make-id "ARGS") sb-ext:*posix-argv* :force? t)
  (let-val (make-id "IN") *standard-input* :force? t)
  (let-val (make-id "OUT") *standard-output* :force? t))

(defun init-io ()
  (init-io-vars)

  (let-type io-type)
  (let-type str-io-type)

  (let-fun dump (pos (val any?))
    (dump-val val *stdout*)
    (terpri *stdout*))

  (let-fun print (pos val)
    (print-val val *stdout*))

  (let-macro with-str-out (pos out (var sym) (body expr))
    (cons `(with-output-to-string (,(lisp-id var))
             ,@(emit-vals (vals body)))
          out)))
