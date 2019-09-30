(in-package lila)

(defclass pos ()
  ((file :initform nil :initarg :file :reader file)
   (row :initform 1 :initarg :row :accessor row)
   (col :initform 0 :initarg :col :accessor col)))

(defvar *pos* nil)

(defun new-pos (&rest args)
  (apply #'make-instance 'pos args))

(defun clone-pos (&optional (pos *pos*))
  (when pos
    (with-slots (file row col) pos
      (make-instance 'pos :file file :row row :col col))))

(defmethod print-object ((p pos) out)
  (with-slots (file row col) p
    (if file
        (format out "~a.~a:~a:~a"
                (pathname-name file)
                (pathname-type file)
                row col)
        (format out "~a:~a" row col))))
