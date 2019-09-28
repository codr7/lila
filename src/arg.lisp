(in-package lila)

(defun get-arg-id (a)
  (intern (symbol-name (if (consp a)
                           (first a)
                           a))))

(defun get-arg-type (a)
  (intern (symbol-name (if (consp a)
                           (get-type-id (if (pair? a) (rest a) (second a)))
                           'any-type))
          'lila))
