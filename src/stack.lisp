(in-package lila)

(defclass stack ()
  ((items :initform (make-array 1 :fill-pointer 0) :reader items)))

(defmacro with-stack ((&optional stack) &body body)
  `(let ((*stack* (or ,stack (make-stack))))
     ,@body))

(defun make-stack ()
  (make-instance 'stack))

(defvar *stack* (make-stack))

(defmacro do-stack ((var in) &body body)
  `(do ((i 0 (1+ i))) ((= i (length ,in)))
     (let ((,var (aref ,in i)))
       ,@body)))

(defun push-val (val)
  (with-slots (items) *stack*
    (vector-push-extend val items)))

(defun pop-val (&key (pos *pos*))
  (with-slots (items) *stack*
    (when (zerop (fill-pointer items))
      (esys pos "Stack is empty"))
    (vector-pop items)))

(defmethod print-object ((s stack) out)
  (let (sep)
    (do-stack (v (items s))
      (if sep
          (write-char #\Space out)
          (setf sep t))
      (print-object v out))))

(defclass $ ()
  ())

(defvar $ (make-instance '$))

(define-type pop ())

(defmethod compile-val ((_ $) in out &key (pos *pos*))
  (declare (ignore pos))
  (values in out))

(defmethod get-type ((-- $)) pop-type)

(defmethod print-object ((-- $) out)
  (write-char #\$ out))

(defmethod splat-val ((-- $))
  (splat-val (pop-val)))

