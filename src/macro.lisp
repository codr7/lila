(in-package lila)

(defclass macro ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs)
   (imp :initarg :imp :reader imp)))

(defmacro let-macro (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  (let ((lid (lisp-id id)))
    `(progn
       (defmethod ,lid (,@args)
         ,@body)
       
       (let-id (make-instance 'macro
                              :id ',id 
                              :nargs ,(- (length args) 2)
                              :imp (symbol-function ',lid))))))

(define-type macro (any))

(defmethod expand ((m macro) in out &key (pos *pos*))
  (with-slots (nargs imp) m
    (when (< (length in) nargs)
      (format t "~a ~a~%" nargs in)
      (esys pos "Not enough arguments: ~a" m))
    (multiple-value-bind (args in) (split in nargs)
      (values in (apply imp pos out (mapcar #'first args))))))

(defmethod get-type ((-- macro)) macro-type)

(defmethod print-object ((m macro) out)
  (format out "~a:Macro" (symbol-name (id m))))



