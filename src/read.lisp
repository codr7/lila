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

(defun separator? (c)
  (or (whitespace? c)
      (char= c #\()
      (char= c #\))
      (char= c #\{)
      (char= c #\})
      (char= c #\:)
      (char= c #\;)
      (char= c #\.)))

(defun read-id (in)
  (let* ((i 0)
         (s (with-output-to-string (out)
             (tagbody
              next
                (let ((c (read-char in nil)))
                  (when c
                    (unless (or (separator? c)
                                (and (char= c #\/) (not (zerop i))))
                      (incf (col *pos*))
                      (incf i)
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

(defun read-sum (in first)
  (labels ((rec (out)
             (let ((c (read-char in nil)))
               (cond
                 ((or (null c) (whitespace? c))
                  (nreverse out))
                 ((separator? c)
                  (unread-char c in)
                  (nreverse out))
                 ((char= c #\/)
                  (incf (col *pos*))
                  (rec out))
                 (t
                  (unread-char c in)
                  (let ((v (read-val in)))
                    (if v
                        (rec (cons (first v) out))
                        (nreverse out))))))))
    (make-sum (rec (list first)))))

(defun read-val (in)
  (skip-whitespace in)
  
  (let* ((*val-pos* (clone-pos))
         (c (peek-char nil in nil))
         (v (case c
              ((nil #\; #\}))
              (#\_
               (read-char in nil)
               (incf (col *pos*))
               _)
              (#\( (read-list in))
              (#\{ (read-expr in))
              (otherwise
               (if (digit-char-p c)
                   (read-num in)
                   (read-id in))))))
    (when v
      (let ((c (read-char in nil)))
        (when c
          (cond
            ((char= c #\:)
             (incf (col *pos*))
             (let ((rv (read-val in)))
               (unless rv
                 (esys *val-pos* "Invalid pair"))
               (setf v (cons v (to-list (first rv))))))
            ((char= c #\.)
             (incf (col *pos*))
             (let ((rv (read-val in)))
                 (unless rv
                   (esys *pos* "Missing action"))
                 (setf v (make-dot v (first rv)))))
            ((char= c #\/)
             (incf (col *pos*))
             (setf v (read-sum in v)))
            (t
             (unread-char c in)))))
      
      (cons v *val-pos*))))

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

                        (let ((out2 (make-expr)))
                          (push (cons out2 *val-pos*) vals)
                          (setf vals (nreverse vals))
                          (read-body out2)))
                       (#\}
                        (incf (col *pos*))
                        (setf vals (nreverse vals)))
                       (otherwise
                        (unread-char c in)
                        (let ((v (read-val in)))
                          (unless v
                            (esys *pos* "Missing expr end"))
                          (push v vals)
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
                  (nreverse out))
                 (t
                  (unread-char c in)
                  (let ((v (read-val in)))
                    (unless v
                      (esys *pos* "Missing list end"))
                    (rec (cons (first v) out))))))))
    (make-lila-list (rec nil))))

(defun read-vals (in &key out)
  (setf out (reverse out))
  (tagbody
   next
     (let ((v (read-val in)))
       (when v
         (push v out)
         (go next))))
  (nreverse out))
