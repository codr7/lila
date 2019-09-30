(in-package lila)

(define-type dot ())

(defclass dot ()
  ((left :initarg :left :reader left)
   (right :initarg :right :reader right)))

(defun make-dot (left right)
  (make-instance 'dot :left left :right right))

(defmethod print-object ((d dot) out)
  (dump-val (left d) out)
  (write-char #\. out)
  (dump-val (right d) out))

(defmethod emit-val ((d dot) &key in out (pos *pos*))
  (with-slots (left right) d
    (emit-val right :in (cons (cons left pos) in) :out out :pos pos)))

(defmethod get-type ((-- dot)) dot-type)

(defmethod to-bool ((-- undef)))
