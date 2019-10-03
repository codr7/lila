![Logo](logo.png)

### intro
[lila](https://github.com/codr7/lila) is a cleaner, less nested, more declarative and more static language based on [Common Lisp](http://www.lispworks.com/documentation/HyperSpec/Front/). 

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

### syntax
Functions and macros are generic with fixed arity. Bare names evaluate to calls and consume the same number of forms as specified arguments.

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

Dot notation allows putting the called macro/function infix.

```
  21.neg.* 2
  
-42
```

### identity/equality

`is` returns `true` when both arguments share the same identity.

```
  42.is 42

true
```
For reference types, such as lists; identity means address.

```
  (42).is (42)

false
```
`equals` may be used to compare values.

```
  (42).equals (42)

true
```

### bindings
Values may be bound to names using `var`.

```
  {
    var foo 42
    foo
  }

42
```

Bound values may be changed using `=`, which is a regular macro. Assignments evaluate to the new value, `3` in the following example.

```
  {
    var foo 1
    + {foo.= 3} 5
  }
  
8
```

Changing non-existing bindings triggers compile time errors.

```
  foo.= 42

System error at row 1, col 0: Unknown id: foo
```

#### constants
Constant bindings are evaluated at compile time and inlined on reference.

```
  {
    const FOO 42
    FOO
  }

42
```

Changing constant bindings triggers compile time errors.

```
  {
    const FOO 1
    FOO.= 3
  }

System error at row 3, col 2: Can't rebind const: FOO
```

### types

#### Meta
`Meta` is the type of all types, including itself.

```
  Meta.type-of

Meta
```

#### None
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

#### Bool
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

#### Pair
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

#### Fun
Functions are generic with fixed arity.

Arguments have type `Any` by default, which doesn't allow missing values. Calling missing functions triggers compile time errors.

```
  {
    fun foo(x) {42}
    _.foo
  }

debugger invoked on a SB-PCL::NO-APPLICABLE-METHOD-ERROR
```

When allowing missing values is exactly what you want, specifying the argument type is all it takes.

```
  {
    fun foo(x:Any?) {42}
    _.foo
  }
  
42
```

By default, functions return the value of the last evaluated form. Return may be used to exit early with optional result.

```
  {
    fun foo() {1 return 2 3}
    foo
  }
  
2
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

### support
Please consider donating if you would like to help [lila](https://github.com/codr7/lila) evolve and improve, each contribution allows me to spend more time and energy on the project.

<a href="https://liberapay.com/codr7/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>