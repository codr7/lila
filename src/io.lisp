(in-package lila)

(defvar *stdin* *standard-input*)
(defvar *stdout* *standard-output*)

(define-symbol-macro *argv* sb-ext:*posix-argv*)

(defun lila-load (filename)
  (with-open-file (in filename)
    (let ((*pos* (new-pos :file filename)))
      (lila-compile (read-vals in)))))

(defmethod dump-val (v out)
  (print-object v out))
