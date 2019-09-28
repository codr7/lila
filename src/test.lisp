(in-package lila)

(defun test-list ()
  (assert (eq (get-type '(1 . 2)) pair-type))
  (assert (eq (get-type '(1 2 3)) list-type)))

(defun test-all ()
  (init-abc)
  (init-math)
  (test-list))
