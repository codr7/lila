![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a toolkit for building programming languages on top of Common Lisp, and a language implemented using it.

### setup
The following shell spell should get you started. Note that [SBCL](http://www.sbcl.org/) and [Quicklisp](https://www.quicklisp.org/beta/) are currently required to build [lila](https://github.com/codr7/lila).

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
The paint is still wet, but what is there works well enough to compile basic [benchmarks](https://github.com/codr7/lila/blob/master/bench/) and generate standalone executables.

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
912
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)