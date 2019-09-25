![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a toolkit for building programming languages on top of [Common Lisp](http://www.lispworks.com/documentation/HyperSpec/Front/), and a language implemented using it.

```
fun fib(n:Int) {
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

  + 35 7

42
```

### status
The paint is still wet, but what is there works well enough to compile basic [benchmarks](https://github.com/codr7/lila/blob/master/bench/) and generate standalone executables.

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
912
```

### basics
Forms are evaluated left to right. [lila](https://github.com/codr7/lila) treats macro and function names as calls, `&` may be used to get a reference. Both are generic with fixed arity, and will consume as many forms when called.

```
  + 1 2 + 3 4

... 3 7
```

The parameter stack is first class, `$` represents the last value.

```
  35 7

... 35 7

  + $ $

... 42
```

`pop` may be used to skip the last value on the stack.

```
  1 2 3 pop

... 1 2
```

Curlies allow controlling evaluation order.

```
  {* 6 {+ 3 4}}
  
... 42
```

In simple cases such as previous example, `;` may be used to reduce nesting.

```
  {* 6; + 3 4}
  
... 42
```

Dot notation allows specifying the called macro/function infix.

```
  + 35 7

... 42
```
```
  35.+ 7

... 42
```

`_` represents missing values, its type is `None`. Suffixing any type except `None` with `?` gives a sum type that also matches missing values.

```
  Int?

... Int?
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)