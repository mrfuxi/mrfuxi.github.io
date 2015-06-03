---
date: 2015-06-03
title: 5 stages of learning Golang
category: blog
disqus_id: 2015-06-03-5-stages-of-learning-golang
code: false
layout: post
---

Though the career of software developer you will learn number of programming languages and other required tools. Learning new one should not be a problem, and in most cases it isn't. Because it's just another language, different syntax some new features and so on.

But is it actually the case?

When I started learning Golang I wanted to write it as something between C++ and Python. Python because it's my main language these days, and C++ because it has similar origin as Golang and needs to be complied.

As you might have expect it was mostly a fight with the language rather pleasant work. It took me some time before I could say that I think I know how to use it properly and leverage it's features.

From perspective of time I can divide the process into **5 stages**.

### Denial

At first I imagine that all my old patterns will fit Golang nicely. It's just a language. Even if something was not straight forward there is always a way to make it happen. After all there is `interace{}` and `reflect` that can make all of the code as generic as you want.

Since I work quite a lot with Python and Django I started building a simple framework that will take care of some boilerplate for me. Who has the time to write such similar code over and over.

It has to work. I will make it work!

### Anger

It worked, sort of. But I did not like my code. That mini framework was bringing very little value while it was causing quite a lot of confusion.

How the hell can you work with so little abstraction?! Why I have to repeat myself so many times - when setting up HTTP handlers, handling errors. And how to test it all? Not just a single function but the whole application or at least *class*.

Is it all worth it?

### Bargaining

There has to be as a way to make my work easier. I was off Goggling for the answer and I found Martini. Looked nice and made some of my code so much simpler. Added a level of abstraction, took care of so much boilerplate. I could remove my mini framework.

I even come up with the way to test whole application in rather functional way.

Using nice library and having tests has to be enough to make my work better, don't you think?

### Depression

It wasn't... While Martini added some abstraction it did not feel correct. My web handlers did not look like a regular handlers. Magic was spreading though the code. Tests where slow and had so much overhead just to put app in the correct state.

That was it. Martini had to go. My approach to the Go, my code and tests had to change!

### Acceptance

And it did changed. Now I know how was it wrong to fight with the language and trying to use it as Python/C++. Go has it's own very distinct character.

I replaced Martini with Gorilla and controller like approach for the handlers. With modularity achieved using proper interfaced my all of my code is now tested and easy to understand.

From the place when I was missing Python features in Go, I enjoy and leverage  Golang's features.

Whenever I hear people talking what is missing in Golang I know that they don't get it. They might know the syntax and other stuff but they don't get it's character.

I accepted it, as whole. In return Golang made me a happy developer.
