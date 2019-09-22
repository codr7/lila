(in-package lila)

(defvar *stack*)

(defclass stack ()
  ((items :initform (make-array 1 :fill-pointer 0) :reader items)))

(defmacro with-stack ((&optional stack) &body body)
  `(let ((*stack* (or ,stack (make-stack))))
     ,@body))

(defun make-stack ()
  (make-instance 'stack))

(defun push-val (val)
  (with-slots (items) *stack*
    (vector-push-extend val items)))

(defun pop-val (&key (pos *pos*))
  (with-slots (items) *stack*
    (when (zerop (fill-pointer items))
      (esys pos "Stack is empty"))
    (vector-pop items)))

(defmethod print-object ((s stack) out)
  (print-object (items s) out))


(defclass $ () ())

(defvar $ (make-instance '$))

(define-type $ (find-class '$))

(defmethod compile-val ((_ $) in out &key (pos *pos*))
  (declare (ignore pos))
  (values in out))

(defmethod get-type ((-- $)) $-type)

(defmethod print-object ((-- $) out)
  (write-char #\$ out))
              
