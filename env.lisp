(in-package lila)

(defvar *env*)

(defclass env ()
  ((items :initform (make-hash-table))))

(defmacro with-env ((&optional env) &body body)
  `(let ((*env* (or ,env (make-env))))
     ,@body))

(defun make-env ()
  (make-instance 'env))

(defun let-val (id val)
  (with-slots (items) *env*
    (when (gethash id items)
      (esys "Dup binding: ~a" id))
    (setf (gethash id items) val)))
