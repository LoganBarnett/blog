---
layout: post
title:  "One True Language"
date:   2015-09-13 13:21:00
categories: programming
published: true
---

I've spent a lot of my tech career pursuing the One True Language, or One True Library, or some means of doing something in a unified way that could serve as an answer to the problems I was having. The polyglot folks would probably just say some langauges are better than others at certain things and so we should use several languages at once when building applications. I'm not sure I agree with this. I believe most of our languages are pretty good at the problem domains we select them for, or at least they could be.

The real problem stems from "I just want to write code". Don't get me wrong - I like learning all of the new tech. I also love the process of discovery. My problem is once I find out about some new way about thinking about my problems, I find the old stuff abborrent. Perhaps this is a justified line of thinking. If you found out you were doing somthing terribly incorrectly, would you continue to do it?

Convincing those around me to adopt this new tech is where things become painful. Introducing a new piece of tech every few months just destroys my credibility. Peers believe I'm just following the hype where ever it goes and am drifting between one new shiny thing to the next. Learning new technology and ways of thinking about our problems shouldn't be viewed this way, but I must live in this world that these folks also occupy. Finding a way to address their needs is important if I'm to get buy-in, or even better, ownership.

Even if I could just keep adopting new things, it becomes evident that I'd leave behind a zoo of technologies. Say I make a bunch of microservices - proof of concepts aren't really needed anymore. Make a tiny service with the new tech and evaluate how it using real stuff. If it becomes obsolete or unusable, deprecate it and replace it with a new micro service representing the Next Best Thing(tm). Backend this way is easy, relatively speaking. What of the front end? What of other domains that aren't web? Non-web engineers are people too, in their own way.

JavaScript has become the bytecode of the web, and despite many language-snobs' protests, it's incredibly ubiquitous and easy to consume. Even the JVM couldn't nail down part the consumption part very well. Got a browser? It runs JavaScript. Done. No VM required. Not everyone wants to write JavaScript, or at least the syntax. Not everyone wants to mutate state because JavaScript makes it easy. As a result, we now have a plethora of languages that transpile to JavaScript. This makes me wonder about interop. How does a ClojureScript library speak to a library written in ghcs, or \*shudder\*... CoffeeScript? Should they need to interop with each other?

Part of me think we need a meta-language. Write the code that _emits_ the code used by your application. I think this problem delegates the problem up the chain, but the problem still exists. When the shiny new meta-language comes in, the old meta language loses favor and now we've got to port our code over or leave the old stuff behind like some mining town whose veins have dried up.

Microservices can communicate with each other, why can't our libraries? The answer can't be "write mini-rest inside of Javascript so you can communicate with Javascript emitted from varying languages". Maybe there's some things we can learn about the simplictiy of rest that makes it so appealing. The data sent to a service might be mutated, but it doesn't mutate _my_ copy of the data. Let's call this the first law:

> Data must be copied, or insured to be immutable.

For other things needed to interop, there needs to be a means of calling functions. Some of these might be methods. Sometimes functions themselves might get passed. That leads me to think of another law:

> Languages must have a means to call any function from another language, and pass it any data it needs.

And finally, because microservices:

> Functionality must be written in small modules.

If we can simply ensure three things, it should be pretty easy to call between these libraries. Rewrites for underadopted technologies become trivial. Phasing out libraries in deprecated tech now becomes easy to do in piecemeal. That assumes consuming the interop code is also trivial. That might need some additional thought.