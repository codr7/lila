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
               (let ((prev-upper? t))
                 (dotimes (i (length s))
                   (let ((c (char s i)))
                     (cond
                       ((upper-case-p c)
                        (when (not prev-upper?)
                          (write-char #\- out))
                        (setf prev-upper? t))
                       (t
                        (setf prev-upper? nil)))
                     (write-char c out))))))
            (t (esys *pos* "Invalid id: ~a" (type-of s)))))
  
   (intern (format nil "~a-TYPE" (string-upcase s)) 'lila))
