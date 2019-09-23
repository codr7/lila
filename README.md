### intro
[lila](https://github.com/codr7/lila) is a devkit for building programming languages on top of Common Lisp, and a language implemented using provided tools.

### setup
The following shell spell should get you started. The project currently requires [SBCL](http://www.sbcl.org/) and [Quicklisp](https://www.quicklisp.org/beta/) to build.

```
$ git clone https://github.com/codr7/lila.git
$ cd lila
$ mkdir dist
$ ./makedist
$ dist/lila
lila

Press Return on empty row to evaluate,
empty input clears stack.

  1
  2 3

#(1 2 3)
```

### status
The paint is still wet, but what is there works and supports compiling [this](https://github.com/codr7/lila/blob/master/bench/pair.lila) and generating standalone executables.

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
912
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)