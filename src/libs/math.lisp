(in-package lila)

(defun init-math ()
  (let-fun + (pos x y)
    (push-val (+ x y)))
  
  (let-fun - (pos x y)
    (push-val (- x y)))
  
  (let-fun * (pos x y)
    (push-val (* x y))))
