(in-package lila)

(defclass expr ()
  ((body :initform nil :initarg :body :reader body)))

(defun make-expr (&rest body)
  (make-instance 'expr :body body))

(defmethod print-object ((e expr) out)
  (print-object (body e) out))
