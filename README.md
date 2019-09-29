![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a cleaner, less nested and more declarative language based on [Common Lisp](http://www.lispworks.com/documentation/HyperSpec/Front/). 

```
fun fib(n:Int) {
  if {n.< 2} n {
    {fib; n.- 1}.+ {fib; n.- 2}
  }
}
```

### setup
The following command sequence will take you from zero to REPL.

Note that [SBCL](http://www.sbcl.org/) and [Quicklisp](https://www.quicklisp.org/beta/) are required to build [lila](https://github.com/codr7/lila).

```
$ git clone https://github.com/codr7/lila.git
$ cd lila
$ ln -s "$(pwd)/lila.asd" ~/quicklisp/local-projects
$ mkdir dist
$ ./makedist
$ dist/lila
lila

Press Return on empty row to evaluate.

  * 6 7

42
```

### status
The current implementation weighs in below 1 kloc and supports everything in this document as well as basic [benchmarks](https://github.com/codr7/lila/blob/master/bench/).

```
$ dist/lila -build dist/pair bench/pair.lila
...
$ dist/pair
76
```

### basics
[lila](https://github.com/codr7/lila) treats bare macro and function names as calls; both are generic with fixed arity, and consume as many forms when called.

```
  * 6 7

42
```

Curlies allow controlling evaluation order.

```
  {* 6 {+ 3 4}}
  
42
```

In simple cases such as previous example, `;` may be used instead to reduce nesting.

```
  {* 6; + 3 4}
  
42
```

Dot notation allows specifying the called macro/function infix.

```
  42.neg
  
-42
```

### types

#### meta
`Meta` is the type of all types, including itself.

```
  type-of Meta

Meta
```

#### none
`None` represents missing values and has exactly one instance named `_`.

```
  type-of _

None
```

Suffixing any type except `None` with `?` evaluates to a sum type that matches the specified type and `None`.

```
  is-a None Int

false
```
```
  is-a None Int?

true
```

#### bool
Booleans can be `true` or `false`.

All values have boolean representations; many are unconditionally `true`, `0` and empty lists being two notable exceptions.

```
  0.bool

false
```
```
  42.bool

true
```

Logical operators are binary, short-circuiting and return the last evaluated argument.

```
  true.and 42

42

  42.or false

42
```

#### pair
Pairs allow treating two values as one.

```
  {
    var foo 1:2
    foo
  }

1:2
```

Pairs are closely related to lists, zipping any value with the empty list evaluates to a one element list.

```
42:()
  
(42)
```

Paired values may be extracted using bindings.

```
  {
    var foo {1:2}
    var a:b foo
    b:a
  }

2:1
```

#### fun
Functions are generic with fixed arity.

Arguments get type `Any` by default, which means they don't allow missing values.

```
  {
    fun foo(x) {42}
    foo _
  }

debugger invoked on a SB-PCL::NO-APPLICABLE-METHOD-ERROR in thread
#<THREAD "main thread" RUNNING {10005084C3}>
```

```
  {
    fun foo(x:Any?) {42}
    foo _
  }
  
42
```

### performance
Optimization level may be set by passing `-speed` on the command line. The accepted range is `0`-`9`, with `9` being the fastest and `0` default.

```
$ dist/lila bench/pair.lila
72
$ dist/lila -speed 9 bench/pair.lila
4
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)