(defsystem lila
  :name "lila"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :licence "MIT"
  :description "Lisp language devkit"
  :serial t
  :components ((:file "lila")
               (:file "util")
               (:file "pos")
               (:file "error")
               (:file "sym")
               (:file "stack")
               (:file "env")
               (:file "type")

               (:file "libs/abc")

               (:file "bool")
               (:file "int")
               (:file "list")
               (:file "test")))

