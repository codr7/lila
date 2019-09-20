(in-package lila)

(defclass pos ()
  ((file :initarg :file :reader file)
   (row :initarg :row :initform 1 :accessor row)
   (col :initarg :col :initform 0 :accessor col)))

(defvar *pos* nil)

(defmacro with-pos ((&optional pos) &body body)
  `(let ((*pos* (or ,pos (new-pos))))
     ,@body))

(defun new-pos (&optional file)
  (make-instance 'pos :file file))

(defmethod clone ((p pos))
  (with-slots (file row col) p
    (make-instance 'pos :file file :row row :col col)))

(defmethod print-object ((p pos) out)
  (with-slots (file row col) p
    (format out "~a.~a:~a:~a"
            (pathname-name file)
            (pathname-type file)
            row col)))
