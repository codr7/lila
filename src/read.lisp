(in-package lila)

(defvar *val-pos*)

(defun skip-wspace (in)
  (tagbody
   skip
     (let ((c (read-char in nil)))
       (when c
         (when (wspace-char-p c)
           (case c
             (#\newline
              (incf (row *pos*))
              (setf (col *pos*) 0))
             (otherwise
              (incf (col *pos*))))
           (go skip))
         (unread-char c in)))))    

(defun read-id (in)
  (let ((s (with-output-to-string (out)
             (tagbody
              next
                (let ((c (read-char in nil)))
                  (when c
                    (unless (or (wspace-char-p c)
                                (char= c #\{)
                                (char= c #\}))
                      (incf (col *pos*))
                      (write-char c out)
                      (go next))
                    (unread-char c in)))))))
    (when (zerop (length s))
      (esys *val-pos* "Invalid input"))

    (make-id s)))

(defun read-num (in)
  (let ((out 0))
    (tagbody
     next
       (let ((c (read-char in nil)))
         (when c
           (when (digit-char-p c)
             (incf (col *pos*))
             (setf out (+ (* out 10) (char-digit c)))
             (go next))
           (unread-char c in))))
    out))

(defun read-val (in)
  (skip-wspace in)
  
  (let* ((*val-pos* (clone *pos*))
         (c (peek-char nil in nil))
         (v (case c
              ((nil #\; #\}))
              (#\_
               (read-char in nil)
               _)
              (#\$
               (read-char in nil)
               $)
              (#\{ (read-expr in))
              (otherwise
               (if (digit-char-p c)
                   (read-num in)
                   (read-id in))))))
    (when v
      (let ((c (read-char in nil)))
        (when c
          (if (char= c #\:)
              (progn
                (incf (col *pos*))
                (let ((rv (read-val in)))
                  (unless rv
                    (esys *val-pos* "Invalid pair"))
                  (setf v (cons v rv))))
              (unread-char c in)))))
    (values v *val-pos*)))

(defun read-expr (in)
  (unless (char= (read-char in nil) #\{)
    (esys *pos* "Invalid expr start"))

  (incf (col *pos*))
  
  (labels ((read-body (out)
             (skip-wspace in)
             
             (with-slots (body) out
               (let ((c (read-char in nil)))
                 (if c
                     (case c
                       (#\;
                        (incf (col *pos*))

                        (let ((next-out (make-expr)))
                          (push (cons next-out *val-pos*) body)
                          (setf body (nreverse body))
                          (read-body next-out)))
                       (#\}
                        (incf (col *pos*))
                        (setf body (nreverse body)))
                       (otherwise
                        (unread-char c in)
                        (multiple-value-bind (v p) (read-val in)
                          (unless v
                            (esys p "Missing expr end"))
                          (push (cons v p) body)
                          (read-body out))))
                     (esys *pos* "Missing expr end"))))))
    (let ((out (make-expr)))
      (read-body out)
      out)))

(defun read-vals (in &key out)
  (setf out (reverse out))
  (tagbody
   next
     (multiple-value-bind (v vp) (read-val in)
       (when v
         (push (cons v vp) out)
         (go next))))
  (nreverse out))
