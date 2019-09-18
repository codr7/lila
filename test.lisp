(in-package lila)

(defun test-stack ()
  (with-stack ()
    (push-val 42)
    (assert (= (pop-val) 42))))

(defun test-list ()
  (with-env ()
    (add-type list-type)
    (add-type pair-type)
    (assert (eq (get-type '(1 . 2)) pair-type))
    (assert (eq (get-type '(1 2 3)) list-type))))

(defun test-all ()
  (with-env ()
    (add-type bool-type)
    (add-type false-type)
    (add-type int-type)
    (add-type list-type)
    (add-type pair-type)
    (add-type true-type))

  (test-stack)
  (test-list))
