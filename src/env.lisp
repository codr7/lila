(in-package lila)

(defclass env ()
  ((items :initform (make-hash-table) :reader items)))

(defmacro with-env ((&optional env) &body body)
  `(let ((*env* (or ,env (make-env))))
     ,@body))

(defun make-env ()
  (make-instance 'env))

(defvar *env* (make-env))

(defmethod clone ((src env))
  (let* ((dst-env (make-env))
         (dst-items (items dst-env)))
    (dohash (k v (items src))
      (setf (gethash k dst-items) v))
    dst-env))

(defun let-val (id val &key (pos *pos*))
  (with-slots (items) *env*
    (when (gethash id items)
      (esys pos "Dup binding: ~a" id))
    (setf (gethash id items) val)))

(defun get-val (id &key default (pos *pos*))
  (with-slots (items) *env*
    (let ((v (gethash id items)))
      (unless (or v default)
        (esys pos "Unknown id: ~a" (symbol-name id)))
      (or v default))))
