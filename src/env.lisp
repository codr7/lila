(in-package lila)

(defvar *env*)

(defclass env ()
  ((items :initform (make-hash-table))))

(defmacro with-env ((&optional env) &body body)
  `(let ((*env* (or ,env (make-env))))
     ,@body))

(defun make-env ()
  (make-instance 'env))

(defun let-val (id val &key (pos *pos*))
  (with-slots (items) *env*
    (when (gethash id items)
      (esys pos "Dup binding: ~a" id))
    (setf (gethash id items) val)))

(defun get-val (id &key (pos *pos*))
  (with-slots (items) *env*
    (let ((v (gethash id items)))
      (when (null v)
        (esys pos "Unknown id: ~a" (symbol-name id)))
      v)))
