(in-package lila)

(defvar *debug* 3)
(defvar *safety* 3)
(defvar *speed* 3)

(defun lila-compile (vals)
  (let ((code (emit-vals vals)))
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    (declare (optimize (debug ,*debug*)
                                       (safety ,*safety*)
                                       (speed ,*speed*)))
                    ,@code))))
