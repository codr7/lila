(in-package lila)

(defclass pos ()
  ((source :initarg :source :reader source)
   (row :initarg :row :reader row)
   (col :initarg :col :reader col)))

(defvar *pos* nil)

(defmacro with-pos ((&optional pos) &body body)
  `(let ((*pos* (or ,pos (new-pos))))
     ,@body))

(defun new-pos (source)
  (make-pos :source source :row 1 :col 0))
