(in-package lila)

(defvar *stdout* *standard-output*)

(defun lila-load (filename &key)
  (with-open-file (in filename)
    (let ((*pos* (new-pos filename)))
      (emit-ops (compile-ops (compile-vals (read-vals in)))))))

(defmethod dump-val (v out)
  (print-object v out))
