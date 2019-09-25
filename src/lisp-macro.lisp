(in-package lila)

(defclass lisp-macro (macro)
  ())

(defmacro let-lisp-macro (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  
  (let ((lid (lisp-id id))
        (arg0 (pop args))
        (arg-types (mapcar (lambda (a)
                             (list (gensym) (get-arg-type a)))
                           args))
        (arg-ids (mapcar #'get-arg-id args)))
    `(progn
       (defmethod ,lid (,@arg-types ,arg0 ,@arg-ids)
         ,@body)
       
       (let-id (make-instance 'lisp-macro
                              :id ',id 
                              :nargs ,(length args)
                              :imp (symbol-function ',lid))))))

(define-type lisp-macro (macro))

(defmethod expand ((m lisp-macro) in out &key (pos *pos*))
  (with-slots (nargs imp) m
    (when (< (length in) nargs)
      (esys pos "Not enough arguments: ~a" m))
    
    (multiple-value-bind (args in) (split in nargs)
      (let (types vals)
        (dolist (v (mapcar #'first args))
          (push (get-type v) types)
          (push v vals))

        (values in (cons (make-emit-op pos
                                       imp
                                       (append (nreverse types)
                                               (cons pos (nreverse vals))))
                         out))))))

(defmethod get-type ((-- lisp-macro)) lisp-macro-type)

(defmethod print-object ((m lisp-macro) out)
  (format out "~a:Macro" (symbol-name (id m))))

