(in-package lila)

(define-type "Str" (any))

(defmethod dump-val ((v string) out)
  (write-char #\" out)
  (write-string v out)
  (write-char #\" out))

(defmethod equal-vals ((x string) (y string))
  (string= x y))

(defmethod get-type ((-- string))
  str-type)
