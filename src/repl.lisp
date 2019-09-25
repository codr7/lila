(in-package lila)

(defun repl ()
  (flet ((fmt (spec &rest args)
           (apply #'format *stdout* spec args)
           (finish-output *stdout*)))
    (fmt "lila v~a~%~%" lila-version)
    (fmt "Press Return on empty row to evaluate,~%")
    (fmt "empty input clears stack.~%~%")
    (let ((buf (make-string-output-stream)))
      (tagbody
       next
         (fmt "  ")
         (let ((in (read-line *stdin* nil)))
           (when in
             (if (string= in "")
                 (progn
                   (setf in (get-output-stream-string buf))
                   (if (string= in "")
                       (setf (fill-pointer *stack*) 0)
                       (restart-case
                           (let* ((*pos* (new-pos))
                                  (vals (read-vals (make-string-input-stream in)))
                                  (imp (lila-compile (compile-vals vals))))
                             (funcall imp))
                         (ignore ()
                           :report "Ignore condition.")))
                   (dump-stack *stdout*)
                   (terpri *stdout*))
                 (write-string in buf))
             (go next)))))))


