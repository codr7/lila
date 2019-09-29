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

Press Return on empty row to evaluate.

  * 6 7

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

#### pair
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

#### fun
Functions are generic with fixed arity.

Function arguments are defined as having type `Any` by default, which means they don't match missing values.

```
  fun foo(x) {x}
  foo _

debugger invoked on a SB-PCL::NO-APPLICABLE-METHOD-ERROR in thread
#<THREAD "main thread" RUNNING {10005084C3}>:
  There is no applicable method for the generic function
    #<STANDARD-GENERIC-FUNCTION COMMON-LISP-USER::|foo419| (1)>
  when called with arguments
    (None test1.lila:2:1 _).
```

```
  fun bar(x:Any?) {x}
  bar _
  
_
```

### performance
`-speed` may be specified on the command line; it accepts values from `0`, which is the default, to `3`.

```
$ dist/lila bench/pair.lila
72
$ dist/lila -speed 3 bench/pair.lila
4
```

### license
[MIT](https://github.com/codr7/lila/blob/master/LICENSE.txt)