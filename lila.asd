(defsystem lila
  :name "lila"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :licence "MIT"
  :description "Lisp language devkit"
  :serial t
  :components ((:file "src/lila")
               (:file "src/util")
               (:file "src/pos")
               (:file "src/error")
               (:file "src/sym")
               (:file "src/stack")
               (:file "src/env")
               (:file "src/type")
               (:file "src/plugin")

               (:file "src/libs/abc")

               (:file "src/bool")
               (:file "src/expr")
               (:file "src/int")
               (:file "src/list")

               (:file "src/read")
               (:file "src/io")
               (:file "src/test")))

