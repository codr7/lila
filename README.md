<a href="https://liberapay.com/codr7/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>

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
The following command sequence should take you from zero to REPL.

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
The current implementation weighs in below 1 kloc and supports everything described in this document.

```
$ dist/lila -build dist/test test/suite.lila
$ dist/test
```

### basics
Functions and macros are generic with fixed arity. Bare names evaluate to calls and consume the same number of forms as arguments.

```
  * 6 7

42
```

Curlies allow grouping forms and controlling evaluation order.

```
  {* 6 {+ 3 4}}
  
42
```

In simple cases such as previous example, `;` may be used to reduce nesting.

```
  {* 6; + 3 4}
  
42
```

Dot notation allows specifying the called macro/function infix.

```
  21.neg.* 2
  
-42
```

`is` returns `true` when both arguments share the same identity.

```
  42.is 42

true
```
For reference types, such as lists in this example; identity means address.

```
  (42).is (42)

false
```
`equals` may be used to compare values.

```
  (42).equals (42)

true
```

### types

#### meta
`Meta` is the type of all types, including itself.

```
  Meta.type-of

Meta
```

#### none
`None` represents missing values and has exactly one instance named `_`.

```
  _.type-of

None
```

Suffixing any type except `None` with `?` evaluates to a sum type that matches the specified type and `None`.

```
  None.is-a Int

false
```
```
  None.is-a Int?

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
  (1 2 3).bool

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

Pairs are closely related to lists, zipping any value with the empty list evaluates to a single-element list.

```
42:()
  
(42)
```

Parts may be extracted using deconstructing bindings.

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

Arguments have type `Any` by default, which doesn't allow missing values.

```
  {
    fun foo(x) {42}
    _.foo
  }

debugger invoked on a SB-PCL::NO-APPLICABLE-METHOD-ERROR in thread
#<THREAD "main thread" RUNNING {10005084C3}>
```

```
  {
    fun foo(x:Any?) {42}
    _.foo
  }
  
42
```

#### sum types
Sum types match any member type.

```
  Int/Bool

Int/Bool

  Int.is-a Int/Bool
  
true
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