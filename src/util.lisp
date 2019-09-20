(in-package lila)

(defmacro dohash ((key val tbl) &body body)
  (let ((i (gensym)) (ok? (gensym)))
    `(with-hash-table-iterator (,i ,tbl)
       (do () (nil)
         (multiple-value-bind (,ok? ,key ,val) (,i)
           (declare (ignorable ,key ,val))
           (unless ,ok? (return))
           ,@body)))))

(defun caps! (s)
  (setf (char s 0) (char-upcase (char s 0)))
  s)

(defun char-digit (c)
  (- (char-code c) (char-code #\0)))
  
(defun find-function (id &optional (pkg *package*))
  (let ((s (find-symbol id pkg)))
    (when s
      (symbol-function s))))

(defun symf (spec &rest args)
  (intern (string-upcase (apply #'format nil spec args))))

(defun whitespace-char-p (c)
  (when (or (char= c #\space) (char= c #\tab) (char= c #\newline))
    c))
