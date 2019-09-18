(in-package lila)

(defun symf (spec &rest args)
  (intern (string-upcase (apply #'format nil spec args))))

(defun caps! (in)
  (setf (char in 0) (char-upcase (char in 0)))
  in)

(defmacro dohash ((key val tbl) &body body)
  (let ((^i (gensym)) (^ok? (gensym)))
    `(with-hash-table-iterator (,^i ,tbl)
       (do () (nil)
         (multiple-value-bind (,^ok? ,key ,val) (,^i)
           (declare (ignorable ,key ,val))
           (unless ,^ok? (return))
           ,@body)))))

(defmacro bind (args vals &body body)
  `(destructuring-bind ,args ,vals ,@body))
