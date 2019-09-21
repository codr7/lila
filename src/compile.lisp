(in-package lila)

(defmethod compile-val (val in out &key (pos *pos*))
  (values in (cons (make-push-op pos val) out)))

(defun compile-vals (in &key out (reverse? t))
  (labels ((rec (in out)
             (if in
                 (let ((v (first in)))
                   (multiple-value-bind (in out)
                       (compile-val (first v) (rest in) out :pos (rest v))
                     (rec in out)))
                 (if reverse? (nreverse out) out))))
    (rec in (if reverse? (reverse out) out))))
