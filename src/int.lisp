(in-package lila)

(define-type num (any))
(define-type int (num))

(defmethod compare-vals ((x number) (y number))
  (cond
    ((< x y) :lt)
    ((= x y) :eq)
    (t :gt)))

(defmethod get-type ((val integer))
  int-type)

(defmethod to-bool ((val integer))
  (> val 0))     
