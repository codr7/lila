(in-package lila)

(defun link (plugin-id &key (pos *pos*))
  (asdf:load-system plugin-id)
  (let ((p (find-package (intern (string-upcase plugin-id) :keyword))))
    (unless p
      (esys pos "Package not found: ~a" plugin-id))
    (let ((f (find-function "lila-plugin" p)))
      (unless f
        (esys pos "Missing ~a:lila-plugin" plugin-id))
      (funcall f))))
  
