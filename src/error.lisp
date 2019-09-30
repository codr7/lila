(in-package lila)

(define-condition esys (error)
  ((pos :initarg :pos :reader pos)
   (msg :initarg :msg :reader msg)))

(defmethod print-object ((e esys) out)
  (write-string (msg e) out))

(defun esys (pos spec &rest args)
  (let ((msg (apply #'format nil spec args)))
    (if pos
        (with-slots (file row col) pos
          (if file
              (setf msg (format nil
                                "System error in ~a at row ~a, col ~a: ~a"
                                file row col msg))
              (setf msg (format nil
                                "System error at row ~a, col ~a: ~a"
                                row col msg))))
        (setf msg (format nil "System error: ~a" msg)))
    
    (error 'esys :pos (clone-pos pos) :msg msg)))
    
