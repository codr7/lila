(in-package lila)

(defclass fun ()
  ((id :initarg :id :reader id)
   (nargs :initarg :nargs :reader nargs)
   (imp :initarg :imp)))

(defmacro add-lila-method (fun arg-types args body)
  `(let ((m (make-instance 'standard-method
                           :qualifiers '()
                           :lambda-list '(,@(mapcar #'first arg-types) ,@args)
                           :specializers (list ,@(mapcar #'second arg-types))
                           :function (lambda (,@(mapcar #'first arg-types) ,@args)
                                       ,@body))))
     (add-method ,fun m)
     m))

(defmacro let-fun (id (&rest args) &body body)
  (setf id (make-id (string-downcase (symbol-name id))))
  
  (let* ((lid (lisp-id id))
         (gf (gensym))
         (arg0 (pop args))
         (arg-types (mapcar (lambda (a)
                              (list (gensym) (get-arg-type a)))
                            args))
         (arg-ids (mapcar #'get-arg-id args)))
    `(progn
       (let ((,gf (find-function ,(symbol-name lid))))
         (unless ,gf
           (setf ,gf (ensure-generic-function ',lid)))
         (let ((m (add-lila-method ,gf ,arg-types ,(cons arg0 arg-ids) ,body)))
           (let-id (make-instance 'fun
                                  :id ',id 
                                  :nargs ,(length args)
                                  :imp (sb-mop:method-function m))))))))

(define-type fun (any))

(defmethod get-type ((-- fun))
  fun-type)

(defmethod call ((f fun) &key (pos *pos*))
  (with-slots (nargs imp) f
    (when (< (length *stack*) nargs)
      (esys pos "Not enough arguments: ~a" f))
    
    (let (types vals)
      (dotimes (-- nargs)
        (let ((v (pop-val)))
          (push (get-type v) types)
          (push v vals)))

      (apply imp `(,@types ,pos ,@vals)))))

(defmethod print-object ((f fun) out)
  (with-slots (id) f
    (format out "~a:Fun" (if id (symbol-name id) #\_))))



