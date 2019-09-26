(in-package lila)

(defun init-math ()
  (let-fun + (pos (x num) (y num))
    (push-val (+ x y)))
  
  (let-fun - (pos (x num) (y num))
    (push-val (- x y)))
  
  (let-fun * (pos (x num) (y num))
    (push-val (* x y)))

  (let-fun abs (pos (x num))
    (push-val (abs x)))

  (let-fun neg (pos (x num))
    (push-val (- x))))
