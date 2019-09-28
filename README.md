![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a cleaner, less nested higher-level language in [Common Lisp](http://www.lispworks.com/documentation/HyperSpec/Front/). 

```
fun fib(n:Int) {
  if {n.< 2} n {
    {fib; n.- 1}.+ {fib; n.- 2}
  }
}
```

### setup
The following script should be enough to get started. Note that [SBCL](http://www.sbcl.org/) and [Quicklisp](https://www.quicklisp.org/beta/) are required to build [lila](https://github.com/codr7/lila).

```
$ git clone https://github.com/codr7/lila.git
$ cd lila
$ ln -s "$(pwd)/lila.asd" ~/quicklisp/local-projects
$ mkdir dist
$ ./makedist
$ dist/lila
lila

Press Return on empty row to evaluate,
empty input clears stack.

  + 35 7

42
```

### status
[lila](https://github.com/codr7/lila) currently weighs in at around 700 lines and supports running all examples in this document as well as basic [benchmarks](https://github.com/codr7/lila/blob/master/bench/) and generating standalone executables.

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
76
```

### basics
[lila](https://github.com/codr7/lila) treats bare macro and function names as calls; both are generic with fixed arity, and consume as many forms when called.

```
  + 1 2 + 3 4

... 3 7
```

Curlies allow controlling evaluation order.

```
  {* 6 {+ 3 4}}
  
... 42
```

In simple cases such as previous example, `;` may be used instead to reduce nesting.

```
  {* 6; + 3 4}
  
... 42
```

Dot notation allows specifying the called macro/function infix.

```
  42.neg
  
... -42
  $.abs
  
... 42
```

`_` represents missing values, its type is `None`. Suffixing any type except `None` with `?` gives a sum type that also matches missing values.

```
  Int?

... Int?
```

### Types

#### Pair
Pairs allow treating two values as one.

```
  {
    var a:b 1:2
    a.dump
    b.dump
  }

1
2
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)