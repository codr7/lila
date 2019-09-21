(in-package lila)

(defun lila-load (filename &key)
  (with-open-file (in filename)
    (let* ((*pos* (new-pos filename))
           (vals (read-vals in))
           (ops (compile-vals vals)))
      ops)))

(defmethod dump-val (v out)
  (print-object v out))
