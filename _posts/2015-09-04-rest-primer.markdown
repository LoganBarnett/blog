---
layout: post
title:  "RESTful primer"
date:   2015-09-04 21:40:00
categories: programming tutorial
---

There's a lot of stuff to know in tech. While it's possible to know conceptually how things work from top to bottom, knowing all of the specifics is another story. I've run into a lot of engineers who just don't understand what it's about at all, so my hope is to clear that up. REST is a very common tool in the web world, and for good reason. If you want to know all of the super specific stuff about REST and look up RFCs, [wikipedia's REST article](https://en.wikipedia.org/wiki/Representational_state_transfer) is probably a good start. This is not that article. The purpose here is to give you a really basic idea of what this whole REST thing is. RESTful APIs are pretty sweet compared to existing alternatives, but more details can be covered in a later post.

Your web browser, when viewing completely static pages, knows only two verbs, `GET` and `POST`. Any time you type in a URL, `GET`. Click on a link? `GET`. Fill out a form and click submit? Not `GET` this time. It can be, but most of the time it'll be a `POST`. Without even looking at your code you can tell if a form submission was a `POST` by clicking the back button in your browser **_after_** the submit is complete. It varies how the browser will represent this, but a warning will reappear telling you that you're about to submit again. `POST`.

Working with data is often thought of as 4 simple actions, which is typically referred to as CRUD:

- **C**reate
- **R**ead
- **U**pdate
- **D**elete

REST is basically CRUD over HTTP. That's really all it is. CRUD is handled in REST by using a series of verbs. These are both common and official:

* POST
* GET
* PUT
* DELETE

There are others, and you can even use some custom ones. Some are in a draft status as a standard and you can still use them. Browsers and services really don't care here. These map more or less directly to CRUD operations:

* POST - Create
* GET - Read
* PUT - Update (I remember that pUt is to Update because of the U)
* DELETE - Delete

These verbs are applied to resource. Resources are specified using a URL. A resource URL uniquely identifies some data, and groupings of data. Apply a verb to the resource and now you have data operations.

```
GET /api/v1/humans
```

With a request like this, I would expect to see the server return a list of humans. `GET` is the verb. What are we getting? `humans`. The `/api/v1` part is a common means of versioning a service, which we'll get to later.

The example below creates a human. The data for how to create the human is expected to be in the HTTP body. How that data is formatted and what data is provided is not for REST to figure out. That's something the API provider needs to document and make aware to the consumer.

```
POST /api/v1/humans
```

This is how you would get a specific human:

```
GET /api/v1/humans?id=12388
```

Rails uses RESTish URLs. The same thing in Rails would look like this:

```
GET /api/v1/humans/12388
```

Let's say we don't like this human. We'll handle this [Cyberman](https://en.wikipedia.org/wiki/Cyberman) style.

```
DELETE /api/v1/humans?id=12388
```

There you have it: Dr. Who is RESTful.

It should be noted that some resources are hard to make into a proper noun (my term, not theirs). Often times people just fall back on `POST`:

```
POST /api/v1/kick_off_long_running_procecss
```

One of the tricky things here is that REST isn't a protocol in a traditional sense. You can make your service 'RESTful' but use totally different verbs or even deviate from the things purposed in the Wikipedia article mentioned above. Nothing is there to strictly enforce that you stay within the bounds of the RFC.

This

```
HOLLA /api/v1/humans/58843
```

is a totally legit means of courting ~~hottie~~ human 58843 in a RESTful manner, provided _that's the the way the server wants to see it_.

REST is merely a loose convention that's easy to both implement and consume in part because it is so loose. The only library you need to produce a RESTful API is an HTTP server that can respond using different verbs for APIs. To consume it, you just need a means of sending an HTTP request with a verb of your choosing (Javascript does this via AJAX, making browsers work as REST consumers). To give an idea of how conventional it is, this is a sample request of me going to Google:

```
GET https://www.google.com/
Host: www.google.com
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:39.0) Gecko/20100101 Firefox/39.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Cache-Control: max-age=0
```

Notice the `GET` right at the start? Honestly you could shorten these headers a bit and still send this over as a plain text file and get back Google's home page. This is what makes REST as a communication standard for request-based messages so damn awesome. We're just leveraging existing stuff in HTTP already.

A big trend lately are SPAs, or Single Page Applications. The browser goes to an HTML page. That HTML page refers to a Javascript file which is the entire application, including the templates needed to display any part of the app using HTML. From there on out, the Javascript application sends RESTful requests to the server and gets tiny (or at least low overhead) JSON documents back.

The old way of doing things is the server is responsible for serving all of the HTML, responsible for navigation, other user state, etc - things that make a server more complicated than it needed to be. In the olden days, before civilization, most of these servers ONLY spoke HTML. That meant it was hard to treat the service as a true data feed. HTML templates change frequently, which can easily break code that's designed to pry certain kinds of data out of it. It's also intensive on the server. When you go to many still-dated sites, the server has to dutifully buffer the ENTIRE web page before it is sent to you. That also means it has to clean up after itself. Work work work. Each HTML page is probably different. Data feeds on the other hand are much easier to cache, and little memory is set aside for sending overhead for data with a format such as JSON.

So what do you use to make RESTful services? You might look into [express.js](http://expressjs.com) for a really slim server and keep your peers thinking you're a fad surfer. [Sinatra](http://www.sinatrarb.com) is a great way to keep you making RESTful services using Ruby so you can keep up your hipster cred. [Jersey](https://jersey.java.net) is also a pretty good means in Java so you can continue to atone for past sins.

There's a bit more out there to making REST services, but hopefully after this you'll have a better idea what is meant when people say they have a RESTful API.