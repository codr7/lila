(in-package lila)

(defmethod emit-val (val &key in out (pos *pos*))
  (declare (ignore pos))
  (values (cons val out) in))

(defun emit-vals (in &key out (reverse? t))
  (labels ((rec (in out)
             (if in
                 (let ((v (first in)))
                   (multiple-value-bind (out2 in2)
                       (emit-val (first v) :in (rest in) :out out :pos (rest v))
                     (rec in2 out2)))
                 (if reverse? (nreverse out) out))))
    (rec in (if reverse? (reverse out) out))))

(defun emit-body (in &key out (reverse? t))
  (let ((prev-env *env*))
    (with-env ((clone-env))
      (let ((code (emit-vals in :out out :reverse? reverse?)) vars)
          (do-env (id v)
            (when (and (undef? v) (eq (get-val id :env prev-env :default _) _))
              (push (lisp-id id) vars)))
          
          (if vars
              `((let (,@vars) ,@code))
              code)))))

(defmethod equal-vals (x y)
  (eql x y))

(defun get-form (in)
  (if (rest in)
      `(progn ,@in)
      (first in)))
