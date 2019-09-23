(ql:quickload "lila")
(in-package lila)

(defun save (filename main)
  (sb-ext:save-lisp-and-die filename
                            :toplevel main
                            :compression t
                            :purify t
                            :executable t))

(defun main ()
  (let ((mode :default)
        files output-filename)
    (with-lila
      (labels ((parse-args (in)
                 (when in
                   (let ((a (pop in)))
                     (cond
                       ((string= a "-build")
                        (setf mode :build)
                        (unless in
                          (error "Missing output filename"))
                        (setf output-filename (pop in)))
                       ((string= a "-repl")
                        (setf mode :repl))
                       (t
                        (push (lila-load a) files)
                        (when (eq mode :default)
                          (setf mode :run)))))
                   (parse-args in))))
        (parse-args (rest *argv*)))
      
      (labels ((run-files ()
                 (dolist (f files)
                   (funcall f)))
               (output-main ()
                 (with-env ()
                   (with-stack ()
                     (run-files)))))
        (case mode
          ((:default :repl)
           (run-files)
           (repl))
          (:build
           (save output-filename #'output-main))
          (:run
           (run-files)))))))

(save (make-pathname :directory '(:relative "dist") :name "lila") #'main)