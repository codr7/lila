(in-package lila)

(defclass fun ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs :reader nargs)
   (imp :initarg :imp)))

(defmacro let-fun (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  
  (let* ((lid (lisp-id id))
         (arg0 (pop args))
         (arg-types (mapcar (lambda (a)
                              (list (gensym) (get-arg-type a)))
                            args))
         (arg-ids (mapcar #'get-arg-id args)))
    `(progn
       (defmethod ,lid (,@arg-types ,arg0 ,@arg-ids)
         ,@body)

       (when (eq (get-val ',id :default _) _)
         (let-id (make-instance 'fun
                                :id ',id 
                                :nargs ,(length args)
                                :imp (fdefinition ',lid)))))))

(define-type fun (any))

(defmethod get-type ((-- fun))
  fun-type)

(defmethod call ((f fun) args &key (pos *pos*))
  (with-slots (nargs imp) f
    (when (< (length args) nargs)
      (esys pos "Not enough arguments: ~a" f))
    
    (let (types vals)
      (dolist (v args)
        (push (get-type v) types)
        (push v vals))

      (apply imp `(,@(nreverse types) ,pos ,@(nreverse vals))))))

(defmethod print-object ((f fun) out)
  (with-slots (id) f
    (format out "~a:Fun" (if id (symbol-name id) #\_))))



