(in-package lila)

(define-type num (any))
(define-type int (num))
          
(defmethod get-type ((val integer))
  int-type)

(defmethod to-bool ((val integer))
  (> val 0))
