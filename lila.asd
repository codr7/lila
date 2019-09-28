(defsystem lila
  :name "lila"
  :version "8"
  :maintainer "codr7"
  :author "codr7"
  :description "Lisp language toolkit"
  :licence "MIT"
  :serial t
  :components ((:file "src/lila")
               (:file "src/util")
               (:file "src/pos")
               (:file "src/error")
               (:file "src/id")

               (:file "src/type")
               (:file "src/arg")
               (:file "src/macro")
               (:file "src/fun")
               
               (:file "src/undef")
                              
               (:file "src/sym")
               (:file "src/env")
               (:file "src/plugin")

               (:file "src/val")
               (:file "src/bool")
               (:file "src/expr")
               (:file "src/int")
               (:file "src/list")

               (:file "src/read")
               (:file "src/io")
               (:file "src/repl")
               (:file "src/test")

               (:file "src/libs/abc")
               (:file "src/libs/math")))

