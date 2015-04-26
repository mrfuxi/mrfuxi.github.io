---
date: 2015-04-26
title: Effective code review
category: blog
disqus_id: 2015-04-26-effective-code-review
code: true
layout: post
---

Sine I moved to a new job, I needed to change how I'm doing code review. Reason for that was simple. While we are using Git, we are not using GitHub or any CI, so all code review has to happen on my local machine.

While this approach has own flaws:

- how to give feedback
- broken tests
- missing coverage

It's good in seance that my reviews got more in deep. After all I need to:

- checkout the branch
- run the tests
- check implementation manually
- prepare a diff
- check the diff

You can say that I first three points should always be done. But when CI run tests for you and GitHub created a diff. Developer not always will check implementation himself. Especially when there is a QA team further on.

Now I almost always **check how implementation behaves in the system**, as some test might not take into consideration other factors.
Not once or twice I've seen implementations that look good on the diff, but the moment you start playing with it cracks start to appear.

Second most important part of review, after making sure implementation actually works is the diff to **see implementation it self**.

It does not appear to be such a big deal, just run `git diff` against your development branch or previous commit (whatever is appropriate in the situation). And at this point you are done, read it and make your judgement...

Regular diff will be just fine, but what about making your life easier? It's known that context switching does not work very well, so why you do that when reading diff? Regular diff will contain all sort of changes that where required to implement feature or a bug fix. It's not uncommon to write certain part of implementation in two or three languages (in web: Python/Ruby/Other + HTML + JS + CSS), even when using one language only you will have tests possibly DB schema migrations. Thanks to `git diff` and modularity of your application you will read implementation, tests, other files from one module, than from the another one (based on sorting files by name).

All of that context switching annoyed me enough to come up with **process that helps me stay focused**. Base steps are to create couple of diff files. One for implementation, one for tests and one for schema migrations (Django). To make implementation even easier to go though I'm sorting files in diff based on file extension. That way I can read back end implementation first then JS, HTML and finally CSS, all grouped together.

As a developer I had to crate shell commands to help me with all that.

I modified `.gitconfig`:

```ini
[alias]
    codediff = !git diff $1 -- $(git diff --name-only $1 | grep -vE "test|migrations")
    testdiff = !git diff $1 -- $(git diff --name-only $1 | grep test)
    migrationsdiff = !git diff $1 -- $(git diff --name-only $1 | grep migrations)
[diff]
    orderfile = ~/.git.orderfile
```

And specified custom order `~/.git.orderfile`:

```
*.py
*.go
*.js
*.html
*.css
*.sass
```

At the end of the day my flow of work looks roughly like that:

- checkout the branch
- run test suite
- test implementation manually
- create code, test and migration diffs
- go though the each diff individually
- merge or fix implementation

All above proven to be very effective when dealing with bigger reviews by reducing context switching.
