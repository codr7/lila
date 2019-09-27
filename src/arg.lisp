(in-package lila)

(defun get-arg-id (a)
  (if (consp a)
      (first a)
      a))

(defun get-arg-type (a)
  (find-class (if (consp a)
                  (get-type-id (if (pair? a) (rest a) (second a)))
                  'any-type)))
