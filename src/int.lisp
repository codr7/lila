(in-package lila)

(define-type "Num" (any))
(define-type "Int" (num))

(defmethod compare-vals ((x number) (y number))
  (cond
    ((< x y) :lt)
    ((= x y) :eq)
    (t :gt)))

(defmethod get-type ((-- integer))
  int-type)

(defmethod to-bool ((v integer))
  (not (zerop v)))     
