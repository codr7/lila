(in-package lila)

(defun lisp-id (id)
  (or (get id :lisp-id)
      (setf (get id :lisp-id)
            (intern (symbol-name (gensym (symbol-name id)))))))

(defun make-id (id)
  (intern id :keyword))

(defun let-id (def)
  (let-val (id def) def))

(defun get-type-id (s)
  (setf s (cond
            ((symbolp s)
             (symbol-name s))
            ((stringp s)
             (with-output-to-string (out)
               (dotimes (i (length s))
                 (let ((c (char s i)))
                   (when (and (upper-case-p c) (not (zerop i)))
                     (write-char #\- out))
                   (write-char c out)))))
            (t (esys nil "Invalid id: ~a" (type-of s)))))
  
   (intern (format nil "~a-TYPE" (string-upcase s)) 'lila))
