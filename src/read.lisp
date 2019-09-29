(in-package lila)

(defvar *val-pos*)

(defun skip-whitespace (in)
  (tagbody
   skip
     (let ((c (read-char in nil)))
       (when c
         (when (whitespace? c)
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
                    (unless (or (whitespace? c)
                                (char= c #\()
                                (char= c #\))
                                (char= c #\{)
                                (char= c #\})
                                (char= c #\:)
                                (char= c #\;)
                                (char= c #\.))
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

(defun read-val (in out)
  (skip-whitespace in)
  
  (let* ((*val-pos* (clone *pos*))
         (c (peek-char nil in nil))
         (v (case c
              ((nil #\; #\}))
              (#\_
               (read-char in nil)
               (incf (col *pos*))
               _)
              (#\.
               (read-char in nil)
               (incf (col *pos*))
               (let ((target (pop out)))
                 (unless target
                   (esys *pos* "Missing target"))
                 (multiple-value-bind (out2 ok?) (read-val in out)
                   (setf out out2)
                   (unless ok?
                     (esys *pos* "Missing call")))
                 (first target)))
              (#\( (read-list in))
              (#\{ (read-expr in))
              (otherwise
               (if (digit-char-p c)
                   (read-num in)
                   (read-id in))))))
    (if v
      (let ((c (read-char in nil)))
        (when c
          (if (char= c #\:)
              (progn
                (incf (col *pos*))
                (multiple-value-bind (out2 ok?) (read-val in out)
                  (setf out out2)
                  (unless ok?
                    (esys *val-pos* "Invalid pair"))
                  (setf v (cons v (first (pop out))))))
              (unread-char c in)))
        
        (when (eq v :empty-list) (setf v nil))
        (values (cons (cons v *val-pos*) out) t))
      (values out nil))))

(defun read-expr (in)
  (unless (char= (read-char in nil) #\{)
    (esys *pos* "Invalid expr start"))

  (incf (col *pos*))
  
  (labels ((read-body (out)
             (skip-whitespace in)
             
             (with-slots (vals) out
               (let ((c (read-char in nil)))
                 (if c
                     (case c
                       (#\;
                        (incf (col *pos*))

                        (let ((next-out (make-expr)))
                          (push (cons next-out *val-pos*) vals)
                          (setf vals (nreverse vals))
                          (read-body next-out)))
                       (#\}
                        (incf (col *pos*))
                        (setf vals (nreverse vals)))
                       (otherwise
                        (unread-char c in)
                        (multiple-value-bind (vals2 ok?) (read-val in vals)
                          (unless ok?
                            (esys *pos* "Missing expr end"))
                          (setf vals vals2)
                          (read-body out))))
                     (esys *pos* "Missing expr end"))))))
    (let ((out (make-expr)))
      (read-body out)
      out)))

(defun read-list (in)
  (unless (char= (read-char in nil) #\()
    (esys *pos* "Invalid list start"))

  (incf (col *pos*))

  (labels ((rec (out)
             (let ((c (read-char in nil)))
               (unless c
                 (esys *pos* "Missing list end"))
         
               (cond
                 ((char= c #\))
                  (incf (col *pos*))
                  (nreverse (mapcar #'first out)))
                 (t
                  (unread-char c in)
                  (multiple-value-bind (out2 ok?) (read-val in out)
                    (unless ok?
                      (esys *pos* "Missing list end"))
                    (rec out2)))))))
    (or (rec nil) :empty-list)))

(defun read-vals (in &key out)
  (setf out (reverse out))
  (tagbody
   next
     (multiple-value-bind (out2 ok?) (read-val in out)
       (setf out out2)

       (when ok?
         (go next))))
  (nreverse out))
