(in-package lila)

(defvar *speed* 0)

(defvar *safety-levels*
  #(3 3 3 2 2 2 1 1 1 0))

(defun lila-compile (vals)
  (let ((code (emit-vals vals)))
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    (declare (optimize (speed ,(floor *speed* 3))
                                       (debug 3)
                                       (safety ,(aref *safety-levels* *speed*))))
                    ,@code))))
