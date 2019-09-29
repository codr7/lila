(in-package lila)

(defvar *speed* 4)

(defvar *debug-levels*
  #(3 2 3 2 1 2 1 0 1 0))

(defvar *safety-levels*
  #(3 3 2 2 2 1 1 1 0 0))

(defun lila-compile (vals)
  (let ((code (emit-vals vals)))
    ;(format t "~a~%" code)
    (compile nil `(lambda ()
                    (declare (optimize (speed ,(floor *speed* 3))
                                       (debug ,(aref *debug-levels* *speed*))
                                       (safety ,(aref *safety-levels* *speed*))))
                    ,@code))))
