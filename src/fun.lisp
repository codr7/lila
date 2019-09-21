(in-package lila)

(defclass fun ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs)
   (imp :initarg :imp)))

(defmacro let-fun (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  (let ((lid (lisp-id id)))
    `(progn
       (defmethod ,lid (,@args)
         ,@body)
       
       (let-id (make-instance 'fun
                              :id ',id 
                              :nargs ,(- (length args) 2)
                              :imp (symbol-function ',lid))))))

(define-type fun (find-class 'standard-generic-function))

(defmethod get-type ((-- fun)) fun-type)

(defmethod call ((f fun) &key (pos *pos*))
  (with-slots (nargs imp) f
    (when (< (length *stack*) nargs)
      (esys pos "Not enough arguments: ~a" f))
    
    (let (args)
      (dotimes (i nargs)
        (push (pop-val) args))
      
      (apply imp pos (mapcar #'first args)))))

(defmethod print-object ((f fun) out)
  (format out "~a:Fun" (symbol-name (id f))))



