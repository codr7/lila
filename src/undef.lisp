(in-package lila)

(defclass undef ()
  ((lila-type :initform any-type :initarg :lila-type :reader lila-type)))

(defun make-undef (&rest args)
  (apply #'make-instance 'undef args))
            
(define-type undef ())
          
(defmethod get-type ((-- undef)) undef-type)

(defmethod to-bool ((-- undef)))

(defmethod undef? (--))
(defmethod undef? ((-- undef)) t)
