(in-package lila)

(defvar *stack*)

(defclass stack ()
  ((items :initform (make-array 1 :fill-pointer 0))))

(defmacro with-stack ((&optional stack) &body body)
  `(let ((*stack* (or ,stack (make-stack))))
     ,@body))

(defun make-stack ()
  (make-instance 'stack))

(defun push-val (val)
  (with-slots (items) *stack*
    (vector-push-extend val items)))

(defun pop-val ()
  (with-slots (items) *stack*
    (vector-pop items)))

