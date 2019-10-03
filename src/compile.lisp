(in-package lila)

(defvar *debug* nil)
(defvar *speed* 0)

(defun lila-compile (vals)
  (let ((code (emit-body vals)))
    (when *debug*
      (format t "~a~%" code))
    
    (compile nil `(lambda ()
                    (declare (optimize (debug 3)
                                       (speed ,(floor *speed* 3))
                                       (safety ,(floor (- 9 *speed*) 3))))
                    ,@code))))
