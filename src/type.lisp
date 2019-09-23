(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)
   (opt-type :initform nil :reader opt-type)))

(defmacro define-type (id (&rest parents))
  (let* ((ids (string-downcase (symbol-name id)))
         (type-id (symf "~a-type" ids))
         forms)
    (unless parents
      (push 'lila parents))

    (push `(defvar ,type-id
             (make-instance ',type-id :id ,(make-id (caps! ids))))
          forms)
    
    (push `(defclass ,type-id (,@(mapcar (lambda (p)
                                           (symf "~a-type"
                                                 (string-downcase (symbol-name p))))
                                         parents))
             ())
          forms)

    (unless (eq type-id 'none-type)
      (let ((opt-ids (format nil "~a?" ids))
            (opt-type-id (symf "~a-opt-type" ids)))
        (push `(setf (slot-value ,type-id 'opt-type)
                     (make-instance ',opt-type-id :id ,(make-id (caps! opt-ids))))
              forms)
        (push `(defclass ,opt-type-id (,type-id none-type)
                 ())
              forms)))
    
    `(progn
       ,@forms)))

(defmethod print-object ((v lila-type) out)
  (write-string (symbol-name (id v)) out))

(define-type any ())
(define-type meta (any))

(defmethod get-type ((val lila-type))
  meta-type)
