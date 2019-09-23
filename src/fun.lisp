(in-package lila)

(defclass fun ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs :reader nargs)
   (imp :initarg :imp)))

(defmacro let-fun (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  (let ((lid (lisp-id id)))
    `(progn
       (defmethod ,lid (,@args)
         ,@body)
       
       (let-id (make-instance 'fun
                              :id ',id 
                              :nargs ,(1- (length args))
                              :imp (symbol-function ',lid))))))

(define-type fun (any))

(defmethod get-type ((-- fun))
  fun-type)

(defmethod call ((f fun) &key (pos *pos*))
  (with-slots (nargs imp) f
    (when (< (length (items *stack*)) nargs)
      (esys pos "Not enough arguments: ~a" f))
    
    (let (args)
      (dotimes (i nargs)
        (push (pop-val) args))

      (apply imp pos args))))

(defmethod print-object ((f fun) out)
  (format out "~a:Fun" (symbol-name (id f))))



