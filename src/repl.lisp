(in-package lila)

(defun repl ()
  (flet ((fmt (spec &rest args)
           (apply #'format *stdout* spec args)
           (finish-output *stdout*)))
    (fmt "lila v~a~%~%" lila-version)
    (fmt "Press Return on empty row to evaluate.~%~%")
    (let ((buf (make-string-output-stream)))
      (tagbody
       next
         (fmt "  ")
         (let ((in (read-line *stdin* nil)))
           (when in
             (if (string= in "")
                 (progn
                   (setf in (get-output-stream-string buf))
                   (restart-case
                       (let* ((*pos* (new-pos))
                              (vals (read-vals (make-string-input-stream in)))
                              (imp (lila-compile vals))
                              (result (funcall imp)))
                         (dump-val (if (null result) _ result) *stdout*)
                         (terpri *stdout*))
                     (ignore ()
                       :report "Ignore condition.")))
                 (write-string in buf))
             (go next)))))))


