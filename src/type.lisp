(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)))

(defmacro define-type (id (&rest parents))
  (let* ((ids (string-downcase (symbol-name id)))
         (type-id (symf "~a-type" ids)))
    (unless parents
      (push 'lila parents))
    
    `(progn
       (defclass ,type-id (,@(mapcar (lambda (p)
                                       (symf "~a-type"
                                             (string-downcase (symbol-name p))))
                                     parents))
         ())
       
       (defvar ,type-id
         (make-instance ',type-id :id ,(make-id (caps! ids)))))))

(defmethod print-object ((v lila-type) out)
  (write-string (symbol-name (id v)) out))

(define-type any ())
(define-type meta (any))

(defmethod get-type ((val lila-type))
  meta-type)
