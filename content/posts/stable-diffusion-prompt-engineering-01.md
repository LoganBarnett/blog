+++
title = "Machine Learning - Stable Diffusion Prompt Engineering"
author = ["Logan Barnett"]
date = 2024-02-06T00:00:00-08:00
aliases = ["/stable-diffusion-prompt-engineering-01.html"]
categories = ["machinelearning"]
draft = false
+++

## <span class="section-num">1</span> Introduction {#introduction}

From my prior adventures during [Nix Adventures Part 2]({{< relref "nix-adventures-02" >}}), I managed to stand up a
local instances of [stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) and I've been having both a lot of fun
and some frustration with it.  This domain is not quite as push-button as I
thought it would be.  There's a lot of information here, some of it dated, and
much of it sitting on YouTube.  I hope this serves as a repository of the
knowledge I gain here.  I will do my best to keep this documentation entirely
reproducible - meaning that you can see version numbers, commit hashes,
generation parameters (seeds, models, sample sizes), etc.  This is one thing I
have found lacking on some of the communities out there.

As of <span class="timestamp-wrapper"><span class="timestamp">[2024-02-11 Sun] </span></span> this is very much still a work in progress and some
sections will be empty or needing better references supplied to it, but don't be
afraid to send me an email with some corrections!  I'll keep this updated, and
will try to keep a loose changelog if you happen to be eager to see updates.


## <span class="section-num">2</span> Prompt Engineering {#prompt-engineering}

<div class="ox-hugo-toc toc has-section-numbers local">

- <span class="section-num">2.1</span> [Prompt Engineering Introduction](#prompt-engineering-introduction)
- <span class="section-num">2.2</span> [Generated](#generated)
    - <span class="section-num">2.2.1</span> [Generating Images - The Code](#generating-images-the-code)
        - <span class="section-num">2.2.1.1</span> [The Lisp Helper](#the-lisp-helper)
        - <span class="section-num">2.2.1.2</span> [Making API calls - A Test](#making-api-calls-a-test)
        - <span class="section-num">2.2.1.3</span> [Making API Calls - A Reusable Block](#making-api-calls-a-reusable-block)
- <span class="section-num">2.3</span> [Sample Prompts](#sample-prompts)
- <span class="section-num">2.4</span> [Inputs](#inputs)
    - <span class="section-num">2.4.1</span> [The Base](#the-base)
    - <span class="section-num">2.4.2</span> [Seed](#seed)
    - <span class="section-num">2.4.3</span> [Classifier Free Guidance (CFG)](#classifier-free-guidance--cfg)
    - <span class="section-num">2.4.4</span> [Samples](#samples)
        - <span class="section-num">2.4.4.1</span> [very low samples](#very-low-samples)
        - <span class="section-num">2.4.4.2</span> [high samples](#high-samples)
        - <span class="section-num">2.4.4.3</span> [very high samples](#very-high-samples)
    - <span class="section-num">2.4.5</span> [Sampling Method](#sampling-method)
    - <span class="section-num">2.4.6</span> [Dimensions](#dimensions)
    - <span class="section-num">2.4.7</span> [High Resolution "Fix"](#high-resolution-fix)
    - <span class="section-num">2.4.8</span> [Refiner](#refiner)
    - <span class="section-num">2.4.9</span> [Batch](#batch)
    - <span class="section-num">2.4.10</span> [Tokens](#tokens)
        - <span class="section-num">2.4.10.1</span> [Token Limits](#token-limits)
        - <span class="section-num">2.4.10.2</span> [Word Salad](#word-salad)
        - <span class="section-num">2.4.10.3</span> [Weights](#weights)
        - <span class="section-num">2.4.10.4</span> [Swapped Tokens](#swapped-tokens)
            - <span class="section-num">2.4.10.4.1</span> [Blending with Steps](#blending-with-steps)
        - <span class="section-num">2.4.10.5</span> [Alternating Tokens](#alternating-tokens)
        - <span class="section-num">2.4.10.6</span> [Tokens - Ceasing and Starting at Specific Steps](#tokens-ceasing-and-starting-at-specific-steps)
        - <span class="section-num">2.4.10.7</span> [Legacy Syntax](#legacy-syntax)
        - <span class="section-num">2.4.10.8</span> [Special Keywords](#special-keywords)
            - <span class="section-num">2.4.10.8.1</span> [Distance](#distance)
            - <span class="section-num">2.4.10.8.2</span> [Style](#style)
            - <span class="section-num">2.4.10.8.3</span> [Artist](#artist)
            - <span class="section-num">2.4.10.8.4</span> [Camera angle](#camera-angle)
    - <span class="section-num">2.4.11</span> [Models](#models)

</div>
<!--endtoc-->


### <span class="section-num">2.1</span> Prompt Engineering Introduction {#prompt-engineering-introduction}

Prompt Engineering is its own discipline, apparently.  For a quick refresher: A
prompt in the context of machine learning is a set of instructions for the
machine learning tool to operate upon.  You might see something like "3D pandas
riding bicycles" or "A robot in a workshop filled with human parts instead of
machine parts".  From those descriptions, the tool will generate something that
matches it.

On a very high level, my understanding is that these tools have
been "trained". This means they are shown a wealth of data (images, in our case)
alongside keywords to identify them.  So they might be shown a picture of a
motorcycle.  The picture includes keywords such as "motorcycle" but also of
"engine", "black" (for the paint), "pavement" (if the background includes such
things), and more.  This is built up as a "network" (a neural network, I think).
It takes a great deal of computing power to train these networks, and I assume a
wealth of very good data.  This requires humans to catalog a lot of stuff, but
perhaps also other machine learning tools that are essentially the inverse of
prompt-to-image generation.  This training produces a "model".

The model is then given a prompt by the consumer of the tool.  The tool will
then offer up some really bad images and say "does this match what was asked
for?", and on the first pass the answer will be a resounding "no", so the tool
takes another pass to clean things up a bit and make things closer, and then the
match check is given again.  You could think of this as the old "draw the owl"
thing from drawing books, wherein one draws some circles that could vaguely
define the outline of the owl.  Then the artist is instructed to draw more and
more details until satisfaction is reached.

{{< figure src="./assets/draw-the-owl01.jpeg" >}}

Though there is a lot of in-between steps.  This process is much like that.
Again though, this is my layman understanding and I hope to revise this as I
learn more.

There is some prior art here.  I have found this [image depicting different
sampling methods](https://i.ibb.co/vm4fm7L/1661440027115223.jpg) but I don't know what all was used and I cannot arbitrarily
add more sampling methods to see how it works.  I don't have a seed to reproduce
the image.


### <span class="section-num">2.2</span> Generated {#generated}

The results of this entire document are generated via literate programming using
`org-babel`.  If you view the source of the original `org-mode` document you can
see how it got generated, and use it to generate your own.  This doesn't use
`stable-diffusion-webui` but instead `stable-diffusion` itself.
`stable-diffusion-webui` it more or less a wrapper around `stable-diffusion`
which translates a web UI into the appropriate Python calls.  We'll be making
the Python calls directly for generating our images, but I will ensure that
these calls match what I see in the UI given the same inputs.

That all makes this document both highly reproducible and easy to update.  You
could even shim in your own models to see what it looks like.  At some point I
might offer an easy diffing mechanism between various models, but for now it'll
just focus on emitting consistent results given its inputs.


#### <span class="section-num">2.2.1</span> Generating Images - The Code {#generating-images-the-code}


##### <span class="section-num">2.2.1.1</span> The Lisp Helper {#the-lisp-helper}

First we need a quick way to evaluate code blocks.  Per the documentation of
`org-babel`, `cache` does not work on the `#+call` form of invoking `org-babel`
blocks.  That said, we can just make blocks of `emacs-lisp` that call a function
for us.  This is that function:

<a id="code-snippet--org-babel-block"></a>
```emacs-lisp
(defun org-babel-block (block, args
  (save-excursion
    (goto-char
    (org-babel-find-named-block block))
    (org-babel-execute-src-block-maybe)
    )
  )
```

And something to catch the missing blocks:

<a id="code-snippet--missing-block"></a>
```emacs-lisp
(message "Error: The 'block' parameter was not provided for org-babel-block.")
```


##### <span class="section-num">2.2.1.2</span> Making API calls - A Test {#making-api-calls-a-test}

The [Wiki based API documentation](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/API) for `stable-diffusion-webui` is not complete.
It does point to a `/docs` that can be accessed on the server.  This is just a
pretty form of a OpenAPI document.  I also don't see the documentation for
actually kicking off a generation of an image using the `txt2image` setup.

I did find this [gist](https://gist.github.com/w-e-w/0f37c04c18e14e4ee1482df5c4eb9f53) with a Python script that got me going.  Thanks `w-e-w`!

In the Wiki link above it is stated that the web UI must be started with `--api`
argument.  I thought surely this had changed since the document was written,
because why wouldn't you want this enabled?  Seems like something you'd disable
explicitly.  Perhaps it's more muggle based.  In any case, it's very much
required.  This tripped me up during my discovery of things.

Of course, once you are running things with `--api`, all of the endpoints show
up correctly in the `/docs` URL.  I should clean this up soon.

<a id="code-snippet--test-text-to-image"></a>
```python
import urllib.request
import base64
import json
import time
import os

file_out = 'test'
payload = {
  'prompt': 'dreamscape',
  'steps': 20,
  'seed': 503043532,
}
request = urllib.request.Request(
    'http://localhost:7860/sdapi/v1/txt2img',
    headers={ 'Content-Type': 'application/json; charset=utf-8' },
    data= json.dumps(payload).encode('utf-8'),
)
response = urllib.request.urlopen(request)
response_data = json.loads(response.read().decode('utf-8'))

for index, image in enumerate(response_data.get('images')):
    path = f'{file_out}-{index}.png'
    with open(path, "wb") as file:
        file.write(base64.b64decode(image))
        print(f'[[file:./{path}]]')
```

{{< figure src="/ox-hugo/test-0.png" >}}


##### <span class="section-num">2.2.1.3</span> Making API Calls - A Reusable Block {#making-api-calls-a-reusable-block}

<a id="code-snippet--text-to-image"></a>
```python
import urllib.request
import base64
import json
import time
import os

payload = {
  'prompt': prompt,
  'steps': samples,
  'seed': 503043532,
}
request = urllib.request.Request(
    'http://localhost:7860/sdapi/v1/txt2img',
    headers={ 'Content-Type': 'application/json; charset=utf-8' },
    data= json.dumps(payload).encode('utf-8'),
)
response = urllib.request.urlopen(request)
response_data = json.loads(response.read().decode('utf-8'))

for index, image in enumerate(response_data.get('images')):
    path = f'{file_out}-{index}.png'
    with open(path, "wb") as file:
        file.write(base64.b64decode(image))
        print(f'[[file:./{path}]]')
```


### <span class="section-num">2.3</span> Sample Prompts {#sample-prompts}

To give a little variety here, let's agree on a few base sample prompts that
should explore a variety of different things we could show.  For each parameter
we choose to tweak, we will use all of these base prompts as well.

These parameters are laid out as a necessity for consistent generation, and it
isn't terribly important that the values are understood for new readers.  This
could serve as good reference though.

<a id="code-snippet--prompt-base-1"></a>
```text
dreamscape
```

<a id="code-snippet--prompt-base-2"></a>
```text
man
```

<a id="code-snippet--prompt-base-3"></a>
```text
woman
```

<a id="code-snippet--prompt-base-4"></a>
```text
city or village or landscape
```

The seed will be:

<a id="code-snippet--prompt-seed"></a>
```text
503043532
```

Our default sample size will be:

<a id="code-snippet--prompt-sample-size"></a>
```text
20
```

Our default model will be:

<a id="code-snippet--prompt-model"></a>
```text
endjourneyXL_v11
```

Our default sampling method will be:

<a id="code-snippet--prompt-sampling-method"></a>
```text
dpm2pp_2m_karras
```

<a id="code-snippet--prompt-height"></a>
```text
512
```

<a id="code-snippet--prompt-width"></a>
```text
512
```

<a id="code-snippet--prompt-cfg"></a>
```text
7
```

The base URL for the `stable-diffusion-webui` server is:

<a id="code-snippet--base-url"></a>
```text
http://localhost:7860
```


### <span class="section-num">2.4</span> Inputs {#inputs}

Various inputs decide the quality of the image, what appears in the image, and
so on.  This includes the prompt itself, but also a lot of other variables.  For
the purposes of illustration, let's use this base image so we can see what the
varied outcomes are.


#### <span class="section-num">2.4.1</span> The Base {#the-base}

As described in [2.3](#sample-prompts), our base is as follows:

<span class="org-target" id="org-target--prompt-base-1"></span>

```emacs-lisp
(org-sbe text-to-image
  (file_out prompt-base-1)
  (prompt prompt-base-1)
 )
```

{{< figure src="/ox-hugo/dreamscape-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out prompt-base-2)
  (prompt prompt-base-2)
 )
```

{{< figure src="/ox-hugo/man-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out prompt-base-3)
  (prompt prompt-base-3)
 )
```

{{< figure src="/ox-hugo/woman-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out prompt-base-4)
  (prompt prompt-base-4)
 )
```

{{< figure src="/ox-hugo/city or village or landscape-0.png" >}}


#### <span class="section-num">2.4.2</span> Seed {#seed}

This should be front an center because it is key to using consistent results.
The seed is a concept taking from random number generators (which this uses
under the hood).  Random number generators aren't actually random but instead
produce a fixed sequence of numbers that appears random.  If you have two random
number generators using the same algorithm and the same seed, they will produce
the exact same two sequences.  This is handy because you can lock in the seed to
refine the existing image by tweaking its parameters.  I've noticed that using a
particular seed also seems to pick the same qualities, even if the parameters or
even the model differ.  I had found a sequence where "cute girl" had produced a
Japanese woman consistently, regardless of other modifiers given that didn't
influence ethnicity.

Seeds will be used heavily in this document to produce consistent results.


#### <span class="section-num">2.4.3</span> Classifier Free Guidance (CFG) {#classifier-free-guidance--cfg}

Stable Diffusion (or perhaps all of these tools) expresses "creativity" in which
it adds things that weren't asked for or ignores parts of your prompt.  This is
called the Classifier Free Guidance scale, or CFG.  A lower number indicates
more freedom on the tool's end, where the lowest number indicates a complete
disregard for the prompt.  The higher it is, the more strictly the prompt is
held to.  At very high numbers, the images will appear "forced".

7 is the default in `stable-diffusion-webui`, which offers a great deal of
creativity.  I am told 15 is "very high", but I don't actually know that I've
seen it do a "bad" job so far at that level.


#### <span class="section-num">2.4.4</span> Samples {#samples}

The number of samples is loosely the number of passes that will be made against
the image.  With `stable-diffusion-webui`, you can see it creating passes
slowly.  Occasionally the UI will load an image in-progress, which starts off
being very fuzzy, and then moves to something full of artifacts, and at some
point later you get the final image.

The number of samples you use increases the fidelity of the image and also will
remove things that are obvious errors (such as poor faces, hands, and so on that
these tools are notorious for).  More samples means the image will take much
longer.  If it takes a minute to generate a 20 sample image, then it will take
around two minutes for 40 samples of the same image.  The default value is 20,
and I have been cautioned that going above 50 is undesirable.  I generally start
at 20 until the main elements of the image are captured, and then regenerate
with the same seed using 50.

Generally I think of this as just doing refinements, but during these trials I
found that sample size can also result in entirely different images.  In some
cases the images just get better - things look less blotchy and ill-defined.  In
the case of the woman, I effectively have a separate image for each run.


##### <span class="section-num">2.4.4.1</span> very low samples {#very-low-samples}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-low-samples"))
  (prompt prompt-base-1)
  (samples 10)
)
```

{{< figure src="/ox-hugo/dreamscape-low-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-low-samples"))
  (prompt prompt-base-2)
  (samples 10)
)
```

{{< figure src="/ox-hugo/man-low-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-low-samples"))
  (prompt prompt-base-3)
  (samples 10)
)
```

{{< figure src="/ox-hugo/woman-low-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-low-samples"))
  (prompt prompt-base-4)
  (samples 10)
)
```

{{< figure src="/ox-hugo/city or village or landscape-low-samples-0.png" >}}


##### <span class="section-num">2.4.4.2</span> high samples {#high-samples}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-high-samples"))
  (prompt prompt-base-1)
  (samples 50)
)
```

{{< figure src="/ox-hugo/dreamscape-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-high-samples"))
  (prompt prompt-base-2)
  (samples 50)
)
```

{{< figure src="/ox-hugo/man-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-high-samples"))
  (prompt prompt-base-3)
  (samples 50)
)
```

{{< figure src="/ox-hugo/woman-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-high-samples"))
  (prompt prompt-base-4)
  (samples 50)
)
```

{{< figure src="/ox-hugo/city or village or landscape-high-samples-0.png" >}}


##### <span class="section-num">2.4.4.3</span> very high samples {#very-high-samples}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-very-high-samples"))
  (prompt prompt-base-1)
  (samples 100)
)
```

{{< figure src="/ox-hugo/dreamscape-very-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-very-high-samples"))
  (prompt prompt-base-2)
  (samples 100)
)
```

{{< figure src="/ox-hugo/man-very-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-very-high-samples"))
  (prompt prompt-base-3)
  (samples 100)
)
```

{{< figure src="/ox-hugo/woman-very-high-samples-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-very-high-samples"))
  (prompt prompt-base-4)
  (samples 100)
)
```

{{< figure src="/ox-hugo/city or village or landscape-very-high-samples-0.png" >}}

Takeaway: The landscape image didn't improve much, but there were notable
improvements on the other images.  More samples just means better.  I'd have to
do higher numbers to get a better idea with diminishing returns.


#### <span class="section-num">2.4.5</span> Sampling Method {#sampling-method}

From my reading, the default DPM2++ 2M Karras (include true identifier) works
best for modern models.  I've heard good things about Euler A but it is either
subjective or for older models.  I need to do a study of how they differ.


#### <span class="section-num">2.4.6</span> Dimensions {#dimensions}

I don't think that height and width are the literal size of the image but I need
to verify this.  This does become a factor with the "Hires fix".


#### <span class="section-num">2.4.7</span> High Resolution "Fix" {#high-resolution-fix}


#### <span class="section-num">2.4.8</span> Refiner {#refiner}


#### <span class="section-num">2.4.9</span> Batch {#batch}


#### <span class="section-num">2.4.10</span> Tokens {#tokens}

A token is effectively a single "thought" or a keyword/keyphrase inside of the
prompt.  With a prompt such as "pandas filing taxes", that phrase gets
tokenized.  How exactly it slices these tokens and interprets them is a complete
mystery to me.

The tokens are treated as a sort of word salad.  There is a limit to the number
of tokens that can be used, with some caveats.  Tokens can be weighted (and
possibly grouped?).  Tokens can also be "stepped" and even alternated with a
cutoff with another token.  There is a standard syntax and a legacy syntax.


##### <span class="section-num">2.4.10.1</span> Token Limits {#token-limits}

There is an upper limit to these tokens in both the positive and negative
prompts.  I do not know if pushing closer to that boundary causes significantly
increased processing time.  That upper limit just breaks the image processing
into two large parts - one part with one set of tokens and another part with the
remaining tokens (or some continuation of that, if you go many multiples over
the limit).  The limit in Stable Diffusion is quite large I have found, with 75
tokens.  I do not know if the tokens between the positive and negative prompts
tally up.


##### <span class="section-num">2.4.10.2</span> Word Salad {#word-salad}

I have noticed that words seem to be taken in any order with no respect to
grammar.  So with "pandas filing taxes", the end result is something to the
effect of "taxes", "pandas", and "filing", and the model goes to work on that.
This can make some problems because if we use "blue hair", we'll get lots of
things that aren't blue, and the hair might remain not-blue.

<a id="code-snippet--word-salad-blue-hair"></a>
```text
blue hair
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-word-salad-blue-hair"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe word-salad-blue-hair)))
)
```

{{< figure src="/ox-hugo/dreamscape-word-salad-blue-hair-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-word-salad-blue-hair"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe word-salad-blue-hair)))
)
```

{{< figure src="/ox-hugo/man-word-salad-blue-hair-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-word-salad-blue-hair"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe word-salad-blue-hair)))
  (samples 30)
)
```

{{< figure src="/ox-hugo/woman-word-salad-blue-hair-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-word-salad-blue-hair"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe word-salad-blue-hair)))
)
```

{{< figure src="/ox-hugo/city or village or landscape-word-salad-blue-hair-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-word-salad-blue-hair"))
  (prompt $(concat (org-sbe prompt-base-3) ", " (org-sbe word-salad-blue-hair)))
  (samples 30)
)
```

{{< figure src="/ox-hugo/woman-word-salad-blue-hair-0.png" >}}

It's interesting in the case of the dreamscape and landscape prompts that it
ignored those and just used a woman, but that is for a later break-down.

Adding just "blue hair" doesn't prove my point well.  I imagine this is because
when the prompt is "man blue hair" that blue men aren't as common as blue hair
on a man, or any colored hair on a man.  Let's try it with an additional prompt:

<a id="code-snippet--word-salad-blue-hair-extra"></a>
```text
, blue hair, red tie
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-word-salad-blue-hair-extra"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe word-salad-blue-hair-extra)))
)
```

{{< figure src="/ox-hugo/dreamscape-word-salad-blue-hair-extra-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-word-salad-blue-hair-extra"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe word-salad-blue-hair-extra)))
)
```

{{< figure src="/ox-hugo/man-word-salad-blue-hair-extra-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-word-salad-blue-hair-extra"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe word-salad-blue-hair-extra)))
)
```

{{< figure src="/ox-hugo/woman-word-salad-blue-hair-extra-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-word-salad-blue-hair-extra"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe word-salad-blue-hair-extra)))
)
```

{{< figure src="/ox-hugo/city or village or landscape-word-salad-blue-hair-extra-0.png" >}}

Okay that's not enough to produce the "swap" issue I've seen.  Let's make this
more complicated and add another color.

<a id="code-snippet--word-salad-blue-hair-red-tie-green-house-hill"></a>
```text
, blue hair, red tie, a green house on a hill
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "word-salad-blue-hair-red-tie-green-house-hill"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe word-salad-blue-hair-red-tie-green-house-hill)))
)
```

{{< figure src="/ox-hugo/dreamscapeword-salad-blue-hair-red-tie-green-house-hill-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "word-salad-blue-hair-red-tie-green-house-hill"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe word-salad-blue-hair-red-tie-green-house-hill)))
)
```

{{< figure src="/ox-hugo/manword-salad-blue-hair-red-tie-green-house-hill-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "word-salad-blue-hair-red-tie-green-house-hill"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe word-salad-blue-hair-red-tie-green-house-hill)))
)
```

{{< figure src="/ox-hugo/womanword-salad-blue-hair-red-tie-green-house-hill-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "word-salad-blue-hair-red-tie-green-house-hill"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe word-salad-blue-hair-red-tie-green-house-hill)))
)
```

{{< figure src="/ox-hugo/city or village or landscapeword-salad-blue-hair-red-tie-green-house-hill-0.png" >}}

Okay now we're seeing some color mixing.  How do we ensure we get what we
wanted?  I've been told this is due to [2.4.10.4](#swapped-tokens).


##### <span class="section-num">2.4.10.3</span> Weights {#weights}

Keywords can be weighted.  This is done via a parenthesis notation around the
keyword, a colon, and a number.  So the keyword `dragon` would indicate you want
to see a dragon.  Using `(dragon: 1.5)` means you want to see a dragon but is
weighted higher than other keywords by a significant margin.  The


##### <span class="section-num">2.4.10.4</span> Swapped Tokens {#swapped-tokens}

Swapped tokens use the syntax `[foo:bar:step]`, were `foo` and `bar` are
individual tokens separated by a colon, and followed by another colon is the
step in the samples at which to switch to the other token.

There is multiple utility here:

1.  Things can be blended together.  One can do something like `[forest:city:20]`
    and the first 20 steps will be making a forest, where the last N steps will
    be that of a city for whatever the forest part was.  This can make
    forest-inspired or forest-looking cities.
2.  Color can be forced to work around issues observed wit [2.4.10.2](#word-salad).  I'm not
    sure how this is done yet.


###### <span class="section-num">2.4.10.4.1</span> Blending with Steps {#blending-with-steps}

<a id="code-snippet--blending-steps-forest"></a>
```text
, forest
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-blending-steps-forest"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe blending-steps-forest)))
)
```

{{< figure src="/ox-hugo/dreamscape-blending-steps-forest-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-blending-steps-forest"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe blending-steps-forest)))
  )
```

{{< figure src="/ox-hugo/man-blending-steps-forest-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-blending-steps-forest"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe blending-steps-forest)))
  )
```

{{< figure src="/ox-hugo/woman-blending-steps-forest-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-blending-steps-forest"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe blending-steps-forest)))
  )
```

{{< figure src="/ox-hugo/city or village or landscape-blending-steps-forest-0.png" >}}

Now let's do something that makes perfect sense: Make a forest of candy canes.

<a id="code-snippet--blending-steps-forest-of-candy-canes"></a>
```text
, [forest:candy-canes:5]
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-blending-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe blending-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/dreamscape-blending-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-blending-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe blending-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/man-blending-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-blending-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe blending-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/woman-blending-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-blending-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe blending-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/city or village or landscape-blending-steps-forest-of-candy-canes-0.png" >}}


##### <span class="section-num">2.4.10.5</span> Alternating Tokens {#alternating-tokens}

Like [2.4.10.4](#swapped-tokens), alternating tokens switch between the tokens every other
step in the sampling.  Let's try the same forest of candy canes, but with
alternating instead of stepped.

<a id="code-snippet--alternating-steps-forest-of-candy-canes"></a>
```text
, [forest|candy canes]
```

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-1) "-alternating-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-1) (org-sbe alternating-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/dreamscape-alternating-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-2) "-alternating-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-2) (org-sbe alternating-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/man-alternating-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-3) "-alternating-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-3) (org-sbe alternating-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/woman-alternating-steps-forest-of-candy-canes-0.png" >}}

```emacs-lisp
(org-sbe text-to-image
  (file_out $(concat (org-sbe prompt-base-4) "-alternating-steps-forest-of-candy-canes"))
  (prompt $(concat (org-sbe prompt-base-4) (org-sbe alternating-steps-forest-of-candy-canes)))
)
```

{{< figure src="/ox-hugo/city or village or landscape-alternating-steps-forest-of-candy-canes-0.png" >}}


##### <span class="section-num">2.4.10.6</span> Tokens - Ceasing and Starting at Specific Steps {#tokens-ceasing-and-starting-at-specific-steps}

Use `[token:step]` to start using `token` at sample step count `step`.  I've
read this can be used to control color.

Use `\[\[token:step]]` to <span class="underline">remove</span> `token` at sample step count `step`.  I do
not know the utility for this one as much.


##### <span class="section-num">2.4.10.7</span> Legacy Syntax {#legacy-syntax}


##### <span class="section-num">2.4.10.8</span> Special Keywords {#special-keywords}


###### <span class="section-num">2.4.10.8.1</span> Distance {#distance}


###### <span class="section-num">2.4.10.8.2</span> Style {#style}


###### <span class="section-num">2.4.10.8.3</span> Artist {#artist}


###### <span class="section-num">2.4.10.8.4</span> Camera angle {#camera-angle}


#### <span class="section-num">2.4.11</span> Models {#models}
