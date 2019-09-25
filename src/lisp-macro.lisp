(in-package lila)

(defclass lisp-macro (macro)
  ())

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

(define-type lisp-macro (macro))

(defmethod expand ((m lisp-macro) in out &key (pos *pos*))
  (with-slots (nargs imp) m
    (when (< (length in) nargs)
      (esys pos "Not enough arguments: ~a" m))
    
    (multiple-value-bind (args in) (split in nargs)
      (values in (cons (make-emit-op pos imp (cons pos (mapcar #'first args)))
                       out)))))

(defmethod get-type ((-- lisp-macro)) lisp-macro-type)

(defmethod print-object ((m lisp-macro) out)
  (format out "~a:Macro" (symbol-name (id m))))

