(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)
   (opt? :initform nil :initarg :opt? :reader opt?)
   (opt-type :initform nil :reader opt-type)))

(defun is-a? (child parent)
  (subtypep (type-of child) (type-of parent)))

(defmacro define-type (id (&rest parents))
  (let* ((ids (string-downcase (symbol-name id)))
         (type-id (symf "~a-type" ids))
         (opt-type-id (symf "~a-opt-type" ids))
         forms)    
    (push `(defvar ,type-id
             (make-instance ',type-id :id ,(make-id (caps! ids))))
          forms)

    (setf parents (mapcar (lambda (p)
                            (symf "~a-type"
                                  (string-downcase (symbol-name p))))
                          (or parents '(lila))))
    
    (unless (eq type-id 'none-type)
      (push opt-type-id parents))
    
    (push `(defclass ,type-id (,@parents)
             ())
          forms)

    (unless (eq type-id 'none-type)
      (push `(sb-mop:add-direct-subclass (find-class ',opt-type-id)
                                         (find-class 'none-type))
            forms)
      (push `(defclass ,opt-type-id (lila-type)
               ())
            forms))
    
    `(progn
       ,@forms)))

(defmethod initialize-instance :after ((obj lila-type) &key)
  (with-slots (id opt-type) obj
    (unless (or (eq (id obj) (make-id "None")) (opt? obj))
      (let ((opt-ids (format nil "~a?" (string-downcase (symbol-name (id obj)))))
            (opt-id (symf "~a-opt-type" (string-downcase (symbol-name (id obj))))))
        (setf opt-type (make-instance opt-id
                                      :id (make-id (caps! opt-ids))
                                      :opt? t))))))

(defun let-type (typ)
  (let-id typ)
  (let-id (opt-type typ)))

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
