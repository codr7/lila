(in-package lila)

(defclass lisp-macro ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs)
   (imp :initarg :imp :reader imp)))

(defmacro let-lisp-macro (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  (let ((lid (lisp-id id)))
    `(progn
       (defmethod ,lid (,@args)
         ,@body)
       
       (let-id (make-instance 'lisp-macro
                              :id ',id 
                              :nargs ,(- (length args) 1)
                              :imp (symbol-function ',lid))))))

(define-type lisp-macro (find-class 'lisp-macro))

(defmethod get-type ((-- lisp-macro)) lisp-macro-type)

(defmethod print-object ((m lisp-macro) out)
  (format out "~a:Macro" (symbol-name (id m))))

