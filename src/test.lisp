(in-package lila)

(defun test-stack ()
  (with-stack ()
    (push-val 42)
    (assert (= (pop-val) 42))))

(defun test-list ()
  (assert (eq (get-type '(1 . 2)) pair-type))
  (assert (eq (get-type '(1 2 3)) list-type)))

(defun test-all ()
  (init-abc)
  (test-stack)
  (test-list))
