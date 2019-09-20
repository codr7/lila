(in-package lila)

(define-condition esys (error)
  ((msg :initarg :msg :reader msg)))

(defmethod print-object ((e esys) out)
  (write-string (msg e) out))

(defun esys (spec &rest args)
  (let ((msg (apply #'format nil spec args)))
    (if *pos*
        (with-slots (file row col) *pos*
          (setf msg (format nil
                            "System error in ~a at row ~a, col ~a: ~a"
                            file row col msg)))
        (setf msg (format nil "System error: ~a" msg)))
    (error 'esys :msg msg)))
    
