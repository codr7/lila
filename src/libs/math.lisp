(in-package lila)

(defun init-math ()
  (let-fun + (pos (x num) (y num))
    (push-val (+ x y)))
  
  (let-fun - (pos (x num) (y num))
    (push-val (- x y)))
  
  (let-fun * (pos (x num) (y num))
    (push-val (* x y))))
