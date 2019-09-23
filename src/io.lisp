(in-package lila)

(defvar *stdin* *standard-input*)
(defvar *stdout* *standard-output*)

(define-symbol-macro *argv*
    (or 
     #+CLISP *args*
     #+SBCL sb-ext:*posix-argv*  
     #+LISPWORKS system:*line-arguments-list*
     #+CMU extensions:*command-line-words*
     nil))

(defun lila-compile (ops)
  (with-env ((clone *env*))
    (let ((code (emit-ops (compile-ops ops))) vars)
      (dohash (id v (items *env*))
        (when (undef? v)
          (push (lisp-id id) vars)))
      (when vars
        (setf code `((let (,@vars) ,@code))))
      (compile nil `(lambda ()
                      ,@code)))))

(defun lila-load (filename)
  (with-open-file (in filename)
    (let ((*pos* (new-pos filename)))
      (lila-compile (compile-vals (read-vals in))))))

(defmethod dump-val (v out)
  (print-object v out)
  (terpri out))
