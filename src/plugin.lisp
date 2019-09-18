(in-package lila)

(defun link (plugin-id)
  (asdf:load-system plugin-id)
  (let ((p (find-package (intern (string-upcase plugin-id) :keyword))))
    (unless p
      (esys "Package not found: ~a" plugin-id))
    (let ((f (find-function "lila-plugin" p)))
      (unless f
        (esys "Missing ~a:lila-plugin" plugin-id))
      (funcall f))))
  
