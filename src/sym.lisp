(in-package lila)

(defmacro lisp-id (id)
  `(get ,id :lisp-id))

(defun make-sym (id)
  (multiple-value-bind (s found?) (intern id)
    (unless found?
      (setf (lisp-id s) (gensym)))
    s))
  
