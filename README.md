![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a toolkit for building programming languages on top of [Common Lisp](http://www.lispworks.com/documentation/HyperSpec/Front/), and a language implemented using it.

```
fun fib(n:Int) (Int) {
  if {n.< 2} n {
    {fib; n.- 1}.+ {fib; n.- 2}
  }
}
```

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

$ 1 2 3
```

### status
The paint is still wet, but what is there works well enough to compile basic [benchmarks](https://github.com/codr7/lila/blob/master/bench/) and generate standalone executables.

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
912
```

### syntax
Forms are evaluated left to right, curlies may be used to alter evaluation order by transforming expressions into values.

```
  {* 6 {+ 3 4}}
  
$ ... 42
```

Expressions may be split using `;`, remaining forms are parsed as a sub-expression.

```
  {* 6; + 3 4}
  
$ ... 42
```

Dot notation may be used to place operations between arguments, the receiver is passed as initial argument to the operation.

```
  + 35 7

$ ... 42
```
```
  35.+ 7

$ ... 42
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)