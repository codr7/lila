(in-package lila)

(defmacro lisp-id (id)
  `(get ,id :lisp-id))

(defun make-id (id)
  (multiple-value-bind (s found?) (intern id)
    (unless found?
      (setf (lisp-id s) (gensym)))
    s))
  
