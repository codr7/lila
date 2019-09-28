(in-package lila)

(defun init-math ()
  (let-fun + (pos (x num) (y num))
    (+ x y))
  
  (let-fun - (pos (x num) (y num))
    (- x y))
  
  (let-fun * (pos (x num) (y num))
    (* x y))

  (let-fun abs (pos (x num))
    (abs x))

  (let-fun neg (pos (x num))
    (- x)))
