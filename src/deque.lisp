(in-package lila)

(defclass deque ()
  ((front :initarg :front :reader front)
   (back :initarg :back :reader back)
   (len :initarg :len :reader len)))

(defun make-deque (&rest in)
  (let ((in2 (cons nil in)))
    (make-instance 'deque :front in2 :back (last in2) :len (1- (length in2)))))

(defun push-front (d val)
  (with-slots (front back len) d
    (push val (rest front))
    (when (zerop len)
      (setf back (rest back)))
    (incf len))
  d)

(defun push-back (d val)
  (with-slots (back len) d
    (setf back (push val (rest back)))
    (incf len))
  d)

(defun pop-front (d)
  (with-slots (front back len) d
    (pop (rest front))
    (when (zerop (decf len))
      (setf back front))))

(defmethod print-object ((d deque) out)
  (print-object (rest (front d)) out))
