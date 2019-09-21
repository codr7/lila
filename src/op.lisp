(in-package lila)

(defclass op ()
  ((pos :initarg :pos)))

(defmethod compile-op (op in out)
  (values in (cons op out)))

(defmethod emit-op (op out)
  out)

(defun compile-ops (in &key out)
  (labels ((rec (in out)
             (if in
                 (multiple-value-bind (in out)
                     (compile-op (first in) (rest in) out)
                   (rec in out))
                 (nreverse out))))
    (rec in (reverse out))))

(defun emit-ops (in &key out)
  (labels ((rec (in out)
             (if in
                 (rec (rest in) (emit-op (first in) out))
                 (nreverse out))))
    (rec in (reverse out))))
