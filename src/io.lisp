(in-package lila)

(defvar *stdout* *standard-output*)

(defun lila-load (filename &key)
  (with-open-file (in filename)
    (let ((*pos* (new-pos filename)))
      (with-env ((clone *env*))
        (let ((code (emit-vals (read-vals in)))
              vars)
            (dohash (id v (items *env*))
              (when (undef? v)
                (push (lisp-id id) vars)))
            (when vars
              (setf code `((let (,@vars) ,@code))))
            (format t "~a~%" code)
            (compile nil `(lambda ()
                            ,@code)))))))

(defmethod dump-val (v out)
  (print-object v out))
