(in-package lila)

(defvar *speed* 0)

(defun lila-compile (vals)
  (let ((code (emit-vals vals)))
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    (declare (optimize (speed ,(floor *speed* 3))
                                       (debug 3)
                                       (safety ,(floor (- 9 *speed*) 3))))
                    ,@code))))
