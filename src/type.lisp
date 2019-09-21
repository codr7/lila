(in-package lila)

(defclass lila-type ()
  ((id :initarg :id :reader id)
   (lisp-class :initarg :lisp-class :reader lisp-class)))

(defmacro define-type (id lisp-id)
  (let ((ids (string-downcase (symbol-name id))))
    `(defvar
         ,(symf "~a-type" ids)
         (make-type ,(caps! ids) ',lisp-id))))

(defmethod print-object ((v lila-type) out)
  (write-string (symbol-name (id v)) out))

(defmethod make-type ((id symbol) lisp-class)
  (make-instance 'lila-type :id id :lisp-class lisp-class))

(defmethod make-type ((id string) lisp-class)
  (make-type (make-id id) lisp-class))

(define-type any t)
(define-type meta (find-class 'lila-type))
