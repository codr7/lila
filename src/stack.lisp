(in-package lila)

(defun make-stack ()
  (make-array 1 :fill-pointer 0))

(defvar *stack* (make-stack))

(defmacro with-stack ((&optional stack) &body body)
  `(let ((*stack* (or ,stack (make-stack))))
     ,@body))

(defmacro do-stack ((var) &body body)
  `(do ((i 0 (1+ i))) ((= i (length *stack*)))
     (let ((,var (aref *stack* i)))
       ,@body)))

(defun push-val (val)
  (vector-push-extend val *stack*))

(defun pop-val (&key (pos *pos*))
  (when (zerop (fill-pointer *stack*))
    (esys pos "Stack is empty"))
  (vector-pop *stack*))

(defun dump-stack (out)
  (let (sep)
    (do-stack (v)
      (if sep
          (write-char #\Space out)
          (setf sep t))
      (dump-val v out))))

(defclass $ ()
  ())

(defvar $ (make-instance '$))

(define-type pop ())

(defmethod compile-val ((_ $) in out &key (pos *pos*))
  (declare (ignore pos))
  (values in out))

(defmethod get-type ((-- $))
  pop-type)

(defmethod print-object ((-- $) out)
  (write-char #\$ out))

(defmethod splat-val ((-- $))
  (splat-val (pop-val)))

