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

(defun lila-compile (vals)
  (let ((code (emit-vals vals)) vars)
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    ,@code))))

(defun lila-load (filename)
  (with-open-file (in filename)
    (let ((*pos* (new-pos :file filename)))
      (lila-compile (read-vals in)))))

(defmethod dump-val (v out)
  (print-object v out))
