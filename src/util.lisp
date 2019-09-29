(in-package lila)

(defun caps! (s)
  (setf (char s 0) (char-upcase (char s 0)))
  s)

(defun char-digit (c)
  (- (char-code c) (char-code #\0)))

(defmacro clock (reps &body body)
  (let ((start (gensym)))
    `(let ((,start (get-internal-run-time)))
       (dotimes (-- ,reps)
         ,@body)
       (floor (- (get-internal-run-time) ,start)
              (floor internal-time-units-per-second 1000)))))

(defmacro derive-class (child parent)
  `(sb-mop:ensure-class
    (class-name ,child)
    :direct-superclasses (adjoin ,parent (sb-mop:class-direct-superclasses ,child))
    :direct-slots (sb-mop:class-direct-slots ,child)))

(defmacro dohash ((key val tbl) &body body)
  (let ((i (gensym)) (ok? (gensym)))
    `(with-hash-table-iterator (,i ,tbl)
       (do () (nil)
         (multiple-value-bind (,ok? ,key ,val) (,i)
           (declare (ignorable ,key ,val))
           (unless ,ok? (return))
           ,@body)))))

(defun find-function (id &optional (pkg *package*))
  (let ((s (find-symbol id pkg)))
    (when s
      (symbol-function s))))

(defun pair? (v)
  (labels ((rec (v)
             (cond ((null v) nil)
                   ((atom v) t)
                   (t (rec (rest v))))))
    (cond ((null v) nil)
          ((atom v) nil)
          (t (rec (rest v))))))

(defun split (in i)
  (if (zerop i)
      (values nil in)
      (let* ((prev (nthcdr (1- i) in))
             (tail (rest prev)))
        (rplacd prev nil)
        (values in tail))))

(defun symf (spec &rest args)
  (intern (string-upcase (apply #'format nil spec args))))

(defun whitespace? (c)
  (when (or (char= c #\space) (char= c #\tab) (char= c #\newline))
    c))
