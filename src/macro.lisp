(in-package lila)

(defclass macro ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs)
   (imp :initarg :imp :reader imp)))

(defmacro let-macro (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  (let* ((lid (lisp-id id))
         (arg0 (pop args))
         (arg1 (pop args))
         (arg-types (mapcar (lambda (a)
                              (list (gensym) (get-arg-type a)))
                            args))
         (arg-ids (mapcar #'get-arg-id args)))
    `(progn
       (defmethod ,lid (,@arg-types ,arg0 ,arg1 ,@arg-ids)
         ,@body)
       
       (let-id (make-instance 'macro
                              :id ',id 
                              :nargs ,(length args)
                              :imp (symbol-function ',lid))))))

(define-type macro (any))

(defmethod expand ((m macro) in out &key (pos *pos*))
  (with-slots (nargs imp) m
    (when (< (length in) nargs)
      (esys pos "Not enough arguments: ~a" m))

    (multiple-value-bind (args in) (split in nargs)
      (let (types vals)
        (dolist (v (mapcar #'first args))
          (push (get-type v) types)
          (push v vals))

        (let ((args `(,@(nreverse types) ,pos ,out ,@(nreverse vals))))
          (values in (apply imp args)))))))

(defmethod get-type ((-- macro)) macro-type)

(defmethod print-object ((m macro) out)
  (format out "~a:Macro" (symbol-name (id m))))



