(in-package lila)

(defmacro lisp-id (id)
  `(or (get ,id :lisp-id)
       (setf (get ,id :lisp-id) (gensym ,id))))

(defun make-id (id)
  (intern id :keyword))

(defun let-id (def)
  (let-val (id def) def))
