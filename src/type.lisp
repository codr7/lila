(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)
   (opt-type :initform nil :reader opt-type)))

(defmacro define-type (id (&rest parents))
  (let* ((ids (string-downcase (symbol-name id)))
         (type-id (symf "~a-type" ids))
         forms)    
    (push `(defvar ,type-id
             (make-instance ',type-id :id ,(make-id (caps! ids))))
          forms)

    (unless (eq type-id 'none-type)
      (let ((opt-type-id (symf "~a-opt-type" ids)))
        (push `(defclass ,opt-type-id (,type-id none-type)
                 ())
              forms)))

    (push `(defclass ,type-id (,@(mapcar (lambda (p)
                                           (symf "~a-type"
                                                 (string-downcase (symbol-name p))))
                                         (or parents '(lila))))
             ())
          forms)
    
    `(progn
       ,@forms)))

(defun let-type (in)
  (let-id in)
  (let-id (opt-type in)))

(defmethod initialize-instance :after ((obj lila-type) &key)
  (with-slots (id opt-type) obj
    (unless (or (eq id (make-id "None"))
                (subtypep (type-of obj) (find-class 'none-type)))
      (let ((opt-ids (format nil "~a?" (string-downcase (symbol-name (id obj)))))
            (opt-id (symf "~a-opt-type" (string-downcase (symbol-name (id obj))))))
        (setf opt-type (make-instance opt-id :id (make-id (caps! opt-ids))))))))

(defmethod print-object ((v lila-type) out)
  (write-string (symbol-name (id v)) out))

(defclass _ ()
  ())

(defvar _ (make-instance '_))

(define-type none ())

(defmethod get-type ((-- _))
  none-type)

(defmethod print-object ((-- _) out)
  (write-char #\_ out))

(define-type any ())
(define-type meta (any))

(defmethod get-type ((val lila-type))
  meta-type)
