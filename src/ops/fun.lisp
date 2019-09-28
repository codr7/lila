(in-package lila)

(defclass fun-op (op)
  ((id :initarg :id :reader id)
   (args :initarg :args :reader args)
   (expr :initarg :expr :reader expr)))

(defun make-fun-op (pos id args expr)
  (make-instance 'fun-op
                 :pos (clone pos)
                 :id (make-id (symbol-name id))
                 :args args
                 :expr expr))

(defmethod compile-op ((op fun-op) in out)
  (with-slots (pos id args expr) op
    (when (eq (get-val id :default _) _)
      (let-id (make-instance 'fun
                             :id id 
                             :nargs (length args)
                             :imp (ensure-generic-function (lisp-id id))))))

  (values in (cons op out)))

(defmethod emit-op ((op fun-op) out)
  (with-slots (pos id args expr) op
    (with-env ((clone-env))
      (dolist (a args)
        (let-val (make-id (symbol-name (get-arg-id a)))
                 (make-undef)
                 :pos pos))

      (let ((fargs (mapcar (lambda (a)
                             (if (and (consp a) (pair? a))
                                 (cons (lisp-id (first a)) (rest a))
                                 (lisp-id a)))
                           args)))
        (cons `(let-fun ,id ,(cons 'pos fargs)
                 ,@(emit-vals (body expr)))
              out)))))

(defmethod print-object ((op fun-op) out)
  (with-slots (id args expr) op
    (format out "FUN(~a ~a ~a)" id args expr)))
