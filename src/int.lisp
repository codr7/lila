(in-package lila)

(define-type num (find-class 'number))
(define-type int (find-class 'integer))
          
(defmethod get-type ((val integer)) int-type)

(defmethod to-bool ((val integer)) (> val 0))
