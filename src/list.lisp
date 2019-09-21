(in-package lila)

(define-type pair (find-class 'list))
(define-type list (find-class 'list))

(defun pair? (v)
  (cond ((null v) nil)
        ((atom v) t)
        (t (pair? (rest v)))))

(defmethod get-type ((v list))
  (if (pair? v)
      pair-type
      list-type))

(defmethod to-bool ((v list))
  (or (pair? v) (> (length v) 0)))
