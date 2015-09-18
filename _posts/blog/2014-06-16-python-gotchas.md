---
date: 2014-06-16
title: Python gotchas
category: blog
disqus_id: 2014-06-16-python-gotchas
code: true
---

There are times in life of every Python developer, when you are staring at the screen and can not explain or even understand what just happened.

I would like to show couple of Python gotchas, that should a bring smile onto your face. At least that's the effect they have on me.

## Identity of an int

Imagine scenario when you're comparing identities of 2 objects, ints in this case (do not confuse with comparing values).

~~~python
>>> list_a = [-6, -5, -1, 0, 1, 10, 256, 257, 999]
>>> list_b = [-6, -5, -1, 0, 1, 10, 256, 257, 999]
>>> for a, b in zip(list_a, list_b):
...     print "{:3} is {:3} -> {}".format(a, b, a is b)

 -6 is  -6 -> False
 -5 is  -5 -> True
 -1 is  -1 -> True
  0 is   0 -> True
  1 is   1 -> True
 10 is  10 -> True
256 is 256 -> True
257 is 257 -> False
999 is 999 -> False
~~~

You might expect to get Falses for all of comparisons, as new int object should get a new address and `is` operator compares addresses. If you did not know that or you don't believe try running that:

~~~python
>>> x = 999
>>> hex(id(x))
'0x18f5948'
>>> y = 999
>>> hex(id(y))
'0x18f59d8'
~~~

Ok, but how can operator behave differently for some ints, that does not make sense!
Actually it does... Numbers between -5 and 256 (inclusive) are special to Python (optimization).
You can look up source code (written in C), it's located in `Objects/intobject.c` (Python 2.x) or in `Objects/longobject.c` (Python 3.x).

~~~c
#ifndef NSMALLPOSINTS
#define NSMALLPOSINTS           257
#endif
#ifndef NSMALLNEGINTS
#define NSMALLNEGINTS           5
#endif
#if NSMALLNEGINTS + NSMALLPOSINTS > 0
/* References to small integers are saved in this array so that they
   can be shared.
   The integers that are saved are those in the range
   -NSMALLNEGINTS (inclusive) to NSMALLPOSINTS (not inclusive).
*/
static PyIntObject *small_ints[NSMALLNEGINTS + NSMALLPOSINTS];
#endif
~~~

Array is then filled in by `_PyInt_Init`.

Interesting thing is that those both boundaries where last time changed in Python 2.5 (from 99 to 256). Lower boundary was moved (from -1 to -5) in Python 2.3.

If someone is interested in reasoning, please look up both bug tickets [99 -> 256](http://bugs.python.org/issue1436243) and [-1 -> -5](http://bugs.python.org/issue561244).

In my opinion that was worth pointing out, because it shows that Python is actually a living organism that is evolving. Secondly you need to remember that Python is just a piece of software and code behind it (including bugs) specifies it behaviour. That is very important, as behaviour presented above is **not** true for PyPy.

## Identity of a string

So you know that when creating new string object you're getting new immutable object. That could lead to conclusion, that every string in Python has is unique as it has it's own memory allocation. Code below would suggest so too:

~~~python
>>> y = 'a-b-c'
>>> x = 'a-b-c'
>>> x is y
False
>>> y = 'a b c'
>>> x = 'a b c'
>>> x is y
False
~~~

But what about that:

~~~python
>>> y = 'abc'
>>> x = 'abc'
>>> x is y
True
>>> y = 'a_b_c'
>>> x = 'a_b_c'
>>> x is y
True
~~~

If you would run code from first example Python will allocate 4 different objects in memory (as suspected). However in the second example Python will allocate only 2 objects! One for each 'abc' and 'a_b_c'. Why is that?

It's another Python optimization. Quoting source code:

> Caching the hash (ob_shash) saves recalculation of a string's hash value.
> Interning strings (ob_sstate) tries to ensure that only one string
> object with a given value exists, so equality tests can be one pointer
> comparison.  This is generally restricted to strings that "look like"
> Python identifiers, although the intern() builtin can be used to force
> interning of any string.
> Together, these sped the interpreter by up to 20%.
> 
> -- <cite>Python 2.7 - `Include/stringobject.h`</cite>

If you're interested in some parts of implementations, look up `PyString_InternInPlace` in `Objects/stringobject.c`.

On top of that **all** strings with length 0 or 1 are also singletons.

While regular strings (length of 2 or more) are stored in `interned` dict. Strings that contain single character are stored in `characters` array. Finally all empty strings are stored as `nullstring` object.

That pattern is specified as [String interning](http://en.wikipedia.org/wiki/String_interning).

Again this behaviour is specific to the implementation, and it's not present in PyPy.

## Fun with generators

This one is not a "gotcha", but well known behaviour, or at least is should be. However it can take you by surprise.

From time to time you need to generate number of SQL based on some attributes. Basically it's the same query with different table name or value in one of clauses.

~~~python
>>> TABLES_TO_TRUNCATE = ['t1', 't2', 't3']
>>> query = "TRUNCATE TABLE {};"
>>> queries = [query.format(table) for table in TABLES_TO_TRUNCATE]
>>> for query in queries:
...     print query
...     execute(query)

TRUNCATE TABLE t1;
TRUNCATE TABLE t2;
TRUNCATE TABLE t3;
~~~

This code will happily truncate all specified tables (`execute` would be helper method that actually do the work).
At this point you are happy and ready to move on. Then someone suggests to use a generator instead of list comprehension. That is very small change and actually... why not.
Just to make sure you're re-running your code to check is everything fine. You might be surprised when it's not working. Take a look at the state after suggested change:

~~~python
>>> TABLES_TO_TRUNCATE = ['t1', 't2', 't3']
>>> query = "TRUNCATE TABLE {};"
>>> queries = (query.format(table) for table in TABLES_TO_TRUNCATE)
>>> for query in queries:
...     print query
...     execute(query)

TRUNCATE TABLE t1;
TRUNCATE TABLE t1;
TRUNCATE TABLE t1;
~~~

Do you know why that happened and how to fix it (without going back to list comprehension)?

Answer is very simple. Because generators are evaluated lazily, when next value is needed, `query` string that contains place holder used by format is replaced after first iteration with already formatted string!
`query` variable should not be reused.

With list comprehension everything works as expected, because it's evaluated immediately.

Happy coding :D