(in-package lila)

(defclass sum ()
  ((members :initarg :members :reader members)))

(defun make-sum (members)
  (make-instance 'sum :members members))

(define-type "Sum" ())

(defmethod get-type ((-- sum)) sum-type)

(defmacro make-sum-type (&rest members)
  (let* ((name (with-output-to-string (out)
                 (let (sep)
                   (dolist (m members)
                     (if sep
                         (write-char #\/ out)
                         (setf sep t))             
                     (write-string (symbol-name m) out)))))
         (tid (get-type-id name)))
    `(progn
       (define-type ,name ())
       
       (let ((sc (find-class ',tid)))
         ,@(mapcar (lambda (m)
                     `(derive-class (find-class ',(get-type-id m)) sc))
                   members))

       (symbol-value ',tid))))

(defmethod emit-val ((v sum) &key in out (pos *pos*))
  (declare (ignore pos))
  (with-slots (members) v
    (values (cons `(make-sum-type ,@members) out) in)))



