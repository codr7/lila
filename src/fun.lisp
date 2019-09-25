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
       
       (let-id (make-instance 'fun
                              :id ',id 
                              :nargs ,(length args)
                              :imp (symbol-function ',lid))))))

(define-type fun (any))

(defmethod get-type ((-- fun))
  fun-type)

(defmethod call ((f fun) &key (pos *pos*))
  (with-slots (nargs imp) f
    (when (< (length *stack*) nargs)
      (esys pos "Not enough arguments: ~a" f))
    
    (let (types vals)
      (dotimes (i nargs)
        (let ((v (pop-val)))
          (push (get-type v) types)
          (push v vals)))

      (apply imp (append (nreverse types) (cons pos (nreverse vals)))))))

(defmethod print-object ((f fun) out)
  (format out "~a:Fun" (symbol-name (id f))))



