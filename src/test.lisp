(in-package lila)

(defun test-stack ()
  (with-stack ()
    (push-val 42)
    (assert (= (pop-val) 42))))

(defun test-list ()
  (with-env ()
    (let-id list-type)
    (let-id pair-type)
    (assert (eq (get-type '(1 . 2)) pair-type))
    (assert (eq (get-type '(1 2 3)) list-type))))

(defun test-load ()
  (with-env ()
    (init-abc)
    (lila-load "~/Dev/Lisp/lila/bench/pair.lila")))

(defun test-all ()
  (with-env ()
    (init-abc))

  (test-stack)
  (test-list))
