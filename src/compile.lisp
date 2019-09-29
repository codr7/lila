(in-package lila)

(defvar *speed* 0)

(defun lila-compile (vals)
  (let ((code (emit-vals vals)))
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    (declare (optimize (debug ,(- 3 *speed*))
                                       (safety ,(- 3 *speed*))
                                       (speed ,*speed*)))
                    ,@code))))
