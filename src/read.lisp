(in-package lila)

(defvar *val-pos*)

(defun skip-whitespace (in)
  (tagbody
   skip
     (let ((c (read-char in nil)))
       (when c
         (when (whitespace-char-p c)
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
                    (when (alpha-char-p c)
                      (incf (col *pos*))
                      (write-char c out)
                      (go next))
                    (unread-char c in)))))))
    (unless (zerop (length s))
      (intern s :keyword))))

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
  (skip-whitespace in)
  
  (let* ((*val-pos* (clone *pos*))
         (c (peek-char nil in nil))
         (v (case c
              ((nil))
              (#\$
               (read-char in nil)
               $)
              (#\{ (read-expr in))
              (otherwise
               (if (digit-char-p c) (read-num in) (read-id in))))))
    (when v
      (setf v (cons v *val-pos*))
      
      (let ((c (read-char in nil)))
        (when c
          (if (char= c #\:)
              (progn
                (let ((rv (read-val in)))
                  (unless rv
                    (with-pos (*val-pos*) (esys "Invalid pair")))
                  (setf v (cons v rv))))
              (unread-char c in))))
      v)))

(defun read-expr (in)
  (unless (char= (read-char in nil) #\{)
    (esys "Invalid expr start"))
  
  (let ((out (make-expr)))
    (with-slots (body) out
      (tagbody
       next
         (let ((v (read-val in)))
           (when v
             (push v body)
             (go next)))))
    (skip-whitespace in)
    (unless (char= (read-char in nil) #\})
      (esys "Invalid expr end"))
    out))
    
(defun read-vals (in)
  (let (out)
    (tagbody
     next
       (let ((v (read-val in)))
         (when v
           (push v out)
           (go next))))
    (nreverse out)))
