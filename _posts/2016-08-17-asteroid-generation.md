---
layout: post
title:  "asteriod generation"
date:   2016-08-17 22:17:00
categories: programming
published: true
---

# Introduction

For my personal project, I'm working on a simple and relaxing asteroid mining
game. It spent a long time as a prototype, simplified from many other
voxel-based games into this one, which feels realistic to achieve. I've been
working on it and the tech around it for years, with irregular spurts of
activity, lots of abandoned paths, and much thrown away work. My plan is to use
WebGL in some form and deploy it to the desktop via the web (or even
[Electron](http://electron.atom.io)), and use
[Cordova](https://cordova.apache.org) to handle the mobile version of it. Since
it's faux 2D with voxels, I think mobile is a viable target. This is pending
tests. Mobile or not, this game needs to be made. I realized this when I was
testing the old Unity prototype, and found myself getting lost playing it long
after I'd tested whatever functionality I was curious about during that run.

There's a lot of ideas going on here. I've been enamoured with
[Bret Victor's Inventing on Principle talk](https://vimeo.com/36579366) -
there's a couple of takeaways from that talk, but the most relevant here is the
"shallow" point: give instant feedback so ideas are not lost. The other idea
going on here is one of composability. Use small and simple parts that can
compose into larger things.

# The Old

I was using Perlin noise to create a level full of asteroids. There was no solid
concept of when an asteroid begins or ends. The levels would end abruptly. Most
importantly, they don't look like asteroids with Perlin noise. I also knew that
a fully fleshed out game about asteroids and mining them would have a variety of
asteroid types and also interestingly varied veins of minerals. A simple Perlin
noise setup wasn't going to cut it.

This is what the level looked like using just perlin noise. Not very asteroid-y.

![perlin noise level](/blog/assets/roid-miner-perlin-level.png)

# The New

So my efforts have been directed towards an editor that would allow me to
quickly slap together patterns for generating asteroids and other things. So far
I have a voxel editor as well as an asteroid generator. My next step is to make
a level generator and vein generator.

The voxel editor is rather simple. It displays all six faces of a cube as a
preview. The server presents a list of assets that can be used. I can make named
voxel types which the rest of the editor will use when doing cube generation.
The voxel editor itself is part of my larger object system. It's defined here as
an object definition:

![voxel definition](/blog/assets/roid-miner-voxel-object-def.png)

Object definitions have a "display" field that allows them to add special
editors that aren't bound to a single field type, or perhaps just information to
generally display. In this case I have the cube-preview, which is a read only
display of the voxel images.

![voxel preview](/blog/assets/roid-miner-cube-preview.png)

To see the display in action and also make some instances of the voxels, the
object instance editor is used. The instance editor allows me to create
instances of any object definition using the fields defined in the object
definition.

![voxel instance](/blog/assets/roid-miner-voxel-instance.png)

# Asteroid Generation

Ok, so we have some voxel instances - now what? On over to the generation
section of the editor. I don't have the generators as part of the object
definitions, although that might be a conversion I make eventually. For now,
they are separate entities. I am going by a blog post from the makers of
[Aaaaa!](http://www.dejobaan.com/aaaaa/) on
[how they do generation](http://www.gamasutra.com/view/feature/174311/procedural_content_generation_.php?print=1).
The real quick and dirty is you make tiny little modules that do things like
create objects, change objects, and filter objects. Each one of these are
separate modules, meaning you can swap out tiny little pieces instead of
changing huge hunks of code and watching everything break. Modular systems used
to compose rich expressions is something we see all over the place. When you
[pipe in the shell](http://ryanstutorials.net/linuxtutorial/piping.php),
[compose commands in vim](http://ferd.ca/vim-and-composability.html), or [string
together functions in your code](http://eloquentjavascript.net/05_higher_order.html),
all of that is taking tiny little things which are easy to understand and
maintain individually, and build them up to something larger. Needless to say,
this has made toying with different kinds of generation very easy to do. I have
a palette of things I can do build an asteroid, and swapping them out is
relatively painless.

Here's an example workflow of creating an asteroid generator:

## Step 1. Create a generator

![create a generator](/blog/assets/roid-miner-generation-step0.png)

## Step 2. Add a sequencer

![generation with just a sequencer](/blog/assets/roid-miner-generation-step1.png)

## Step 3. Apply perlin noise

Note that the asteroid preview rotates over time.

![add noise](/blog/assets/roid-miner-generation-step2.png)

## Step 4. Connect points from gaps introduced by perlin noise

This is required for the fill to work properly.

![connect points for filling](/blog/assets/roid-miner-generation-step3.png)

## Step 5. Apply a fill to the center of the asteroid

![fill](/blog/assets/roid-miner-generation-step4.png)

# Closing

This is where I am currently. All of this gets stored in a mongodb server - not
the generated asteroids themselves but the data used to generate them.

My next step will be to create a means of combining a partition component with
the asteroid generators invoked multiple times in a single parent generator.
This generator will build the level. The partitioning will hopefully be my next
post, as there's some juicy bits there.

Until next time!
