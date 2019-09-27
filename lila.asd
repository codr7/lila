(defsystem lila
  :name "lila"
  :version "7"
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
               (:file "src/lisp-macro")
               (:file "src/fun")
               
               (:file "src/undef")
                              
               (:file "src/sym")
               (:file "src/stack")
               (:file "src/env")
               (:file "src/plugin")

               (:file "src/op")
               (:file "src/ops/call")
               (:file "src/ops/const")
               (:file "src/ops/do")
               (:file "src/ops/emit")
               (:file "src/ops/get")
               (:file "src/ops/push")
               (:file "src/ops/splat")
               (:file "src/ops/var")

               (:file "src/bool")
               (:file "src/expr")
               (:file "src/int")
               (:file "src/list")

               (:file "src/read")
               (:file "src/val")
               (:file "src/io")
               (:file "src/repl")
               (:file "src/test")

               (:file "src/libs/abc")
               (:file "src/libs/math")))

