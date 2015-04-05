---
date: 2014-05-26
title: Pyp split brain
category: blog
disqus_id: 2014-05-26-pyp-split-brain
---

>"The Pyed Piper", or pyp, is a linux command line text manipulation tool similar to awk or sed, but which uses standard python string and list methods as well as custom functions evolved to generate fast results in an intense production environment.
>
> -- <cite>[Sony](http://opensource.imageworks.com/?p=pyp)</cite>

Fist checkout the [demo video on YouTube](https://www.youtube.com/watch?v=eWtVWF0JSJA).

It all looks very good. Guys from Sony did a very good job. Additionally the fact that it's Python makes it all even better, as almost everything with Python is better ;)
But is it really that good?

Don't get me wrong. I'm all for simplification of the life, especially using Python. But isn't that crossing some kind of line, [proposed by Unix](http://en.wikipedia.org/wiki/Unix_philosophy)?

(That is the moment when my Python brain fights against Unix brain)

**Unix brain:**
Unix shell is giving you all the power you need, and there is still some more to grab, if you know how. What else do you need?

**Python brain:**
Python is and an infinite power. Pyp let you use that power to parse text in shell like fashion.

**Unix brain:**
It's almost Python. The *almost* is a key word. To use it's power you need to learn very specific functionality.

**Python brain:**
But I know Python, how hard could it be to remember couple of variables and functions.
Once *time saving and often used* functionality is created it can be saved to be easily reused.

**Unix brain:**
It's saved to *some* location, and you don't know where or how to recreate it.

**Python brain:**
Yeah, yeah. It's all in the source code. Just look it up.
This package gives you all what you need, in one place.

**Unix brain:**
Heh, all you need is a [KISS](http://en.wikipedia.org/wiki/KISS_principle)...

### Summary

Assuming you will go for it and start using ``pyp``, all is fine and dandy.
Then one day you need to do some work on other machine (when paring or working on remote box).
Are you going to say: *"Wait, I just need to install this python package..."*, because you don't know how to use standard Unix commands?
I would feel very embarrassed.
Last time when I heard: *Email me this file and I will write a Perl script to parse it*, I thought is was a joke.

Just learn damn shell! It will serve you well for a years to come, and you can embarrass others as a bonus :D

Jokes aside, I will try to give Pyp a chance, but shell is the way to go.
