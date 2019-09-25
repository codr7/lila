(in-package lila)

(defun get-arg-id (a)
  (if (pair? a)
      (first a)
      a))

(defun get-arg-type (a)
  (if (pair? a)
      (symf "~a-type" (string-downcase (symbol-name (rest a))))
      'any-type))
