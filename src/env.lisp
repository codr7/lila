(in-package lila)

(defun make-env ()
  (make-hash-table))

(defvar *env* (make-env))

(defmacro with-env ((&optional env) &body body)
  `(let ((*env* (or ,env (make-env))))
     ,@body))

(defmacro do-env ((k v) &body body)
  `(dohash (,k ,v *env*)
     ,@body))

(defun clone-env ()
  (let ((dst (make-env)))
    (dohash (k v *env*)
      (setf (gethash k dst) v))
    dst))

(defun let-val (id val &key (pos *pos*))
  (when (gethash id *env*)
    (esys pos "Dup binding: ~a" id))
  (setf (gethash id *env*) val))

(defun get-val (id &key default (env *env*) (pos *pos*))
  (let ((v (gethash id env)))
    (unless (or v default)
      (esys pos "Unknown id: ~a" (symbol-name id)))
    (or v default)))
