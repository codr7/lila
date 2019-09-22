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
               (:file "src/id")
               (:file "src/type")
               
               (:file "src/macro")
               (:file "src/lisp-macro")

               (:file "src/fun")
               (:file "src/libs/abc")
               
               (:file "src/op")
               (:file "src/ops/call")
               (:file "src/ops/const")
               (:file "src/ops/do")
               (:file "src/ops/emit")
               (:file "src/ops/get")
               (:file "src/ops/push")

               (:file "src/sym")
               (:file "src/stack")
               (:file "src/env")
               (:file "src/plugin")

               (:file "src/bool")
               (:file "src/expr")
               (:file "src/int")
               (:file "src/none")
               (:file "src/list")

               (:file "src/read")
               (:file "src/compile")
               (:file "src/io")
               (:file "src/test")))

