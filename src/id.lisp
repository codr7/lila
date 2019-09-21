(in-package lila)

(defmacro lisp-id (id)
  `(get ,id :lisp-id))

(defun make-id (id)
  (multiple-value-bind (s found?) (intern id :keyword)
    (unless found?
      (setf (lisp-id s) (gensym)))
    s))

(defun let-id (def)
  (let-val (id def) def))
