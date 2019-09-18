(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)
   (lisp-class :initarg :lisp-class :reader lisp-class)
   (parents :initform (make-hash-table) :reader parents)
   (children :initform (make-hash-table) :reader children)))

(defmacro define-type (id lisp-id (&rest parents))
  (let ((ids (string-downcase (symbol-name id))))
    `(defvar
         ,(symf "~a-type" ids)
         (make-type ,(caps! ids) ',lisp-id ,@parents))))

(defmethod print-object ((v lila-type) out)
  (write-string (symbol-name (id v)) out))

(defmethod make-type ((id string) lisp-class &rest parents)
  (apply #'make-type (make-sym id) lisp-class parents))

(defmethod make-type ((id symbol) lisp-class &rest parents)
  (let ((type (make-instance 'lila-type :id id :lisp-class lisp-class)))
    (dolist (p parents)
      (derive p type))
    type))

(defun add-type (type)
  (let-val (id type) type))

(defun derive (parent child &optional (root parent))
  (setf (gethash parent (parents child)) root)
  (dohash (p _ (parents parent))
    (derive p child root))

  (setf (gethash child (children parent)) root)
  (dohash (c _ (children child))
    (derive parent c root)))
