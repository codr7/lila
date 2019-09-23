(in-package lila)

(defun repl ()
  (flet ((fmt (spec &rest args)
           (apply #'format *stdout* spec args)
           (finish-output *stdout*))
         (indent ()
           (write-string "   " *stdout*)
           (finish-output *stdout*)))
    (fmt "lila v~a~%~%" lila-version)
    (fmt "Press Return on empty row to evaluate,~%")
    (fmt "empty input clears stack.~%~%")
    (let ((buf (make-string-output-stream)))
      (tagbody
       next
         (indent)
         (let ((in (read-line *stdin* nil)))
           (when in
             (if (string= in "")
                 (restart-case
                     (let* ((*pos* (new-pos))
                            (code (get-output-stream-string buf))
                            (vals (read-vals (make-string-input-stream code)))
                            (imp (lila-compile (compile-vals vals))))
                       (funcall imp)
                       (fmt "~a~%" *stack*))
                   (ignore ()
                      :report "Ignore condition."))
                 (write-string in buf))
             (go next)))))))


