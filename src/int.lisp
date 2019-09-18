(in-package lila)

(define-type num (find-class 'number) (any-type))
(define-type int (find-class 'integer) (num-type))
          
(defmethod get-type ((val integer)) int-type)

(defmethod to-bool ((val integer)) (> val 0))
