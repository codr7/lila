(ql:quickload "lila")
(in-package lila)

(defun main ()
  (format t "Hello World~%"))

(sb-ext:save-lisp-and-die (make-pathname :directory '(:relative "dist")
                                         :name "lila")
                          :toplevel #'main
                          :compression t
                          :purify t
                          :executable t)
