+++
title = "Checklist for Good Command Line Programs"
author = ["Logan Barnett"]
date = 2022-08-29T00:00:00-07:00
aliases = ["/command-line-programs.html"]
draft = false
+++

## Introduction {#introduction}

This is to provide a detailed checklist on what makes for a good command line
program.

The quick list:

1.  Provide usage information.
2.  Output parse-able output to `stdout`.
3.  Output logging to `stderr`.
4.  Have a `--help` that describes basic usage and general purpose.
5.  Use exit code 0 for expected results, and positive, non-zero exit codes for
    unexpected results.


## Disclaimer {#disclaimer}

You can always view my [résumé]({{< relref "resume" >}}) here on the blog.  From that you can infer a lot
about my experience and things I've done.  I don't wish to appeal to authority,
but having some experience in the field should amount to something.  I deal with
this stuff on a day to day basis, and from that I've learned some things.  You
can decide for yourself if it's poorly acquired trauma or wisdom that comes with
age.

I tend to examine "standards" with high levels of scrutiny, as they can be put
together by almost anyone with vast quantities of spare time and an unhealthy
addiction to work.  I hope my work here is placed under similar scrutiny.  Bad
ideas should perish and good ideas should thrive.  Of course, the real world
contains a lot of nuance.  I find it best to know what the ideal course is, and
then deviate as needs dictate.

You will not gain my support by quoting my words as truth.  But use this to be
inspired to pitch your own arguments and form your own ideas.

In short: I know some things.  I think to think for myself.  So should you,
including scrutinizing anything I emit.


## Help and Usage {#help-and-usage}

The [Agile Manifesto](https://agilemanifesto.org) tells us to favor "working software over comprehensive
documentation", but I find this akin to waiting until someone falls in a hole
and dies before you decide to put up a sign that there's a hole where one could
fall in and die.

Providing a help/usage information for your program is a must-have. Even
simplistic programs should provide a brief description of what they do and any
arguments they expect. The <span class="underline">program</span> must provide this information, not your
code (though that has incredible merit as well).

When a program isn't provided the information it needs, the **minimal** operation
is to display the usage information and quit with a non-zero exit code.

The usage information itself describes the arguments available, order (if
applicable), required arguments vs. optional, and if the argument can be
repeated (such as file names).

IEEE has a [Utility Conventions](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html) document that covers a standard formatting
convention to use. Most programs I've seen use this convention, and there's not
really a great reason to abandon it. Many command line argument libraries
provide this usage information automatically, but the onus is always on the
program maintainer to provide documentation as to the purpose of the arguments
themselves.

Some programs can be very complicated and so require lots of explanations,
examples, warnings, etc. This is where a [manual page](https://liw.fi/manpages/) (or "man page") comes in
handy. I wouldn't worry too much about the ancient `troff` format. [Pandoc](https://pandoc.org/)
supports [groff](https://www.gnu.org/software/groff/groff.html) (GNU's `troff`) and therefore can convert Markdown and Org-mode
documents to man pages. Though I would check to make sure the output is rendered
in a canonical fashion: There might be things in `troff` that a format like
Markdown doesn't represent well like glossary definitions, for example.

Your bare minimum can include the script name (which can typically be determined
automatically), and any arguments you need.

Here's an example of a bash script with zero arguments. You can use `$0` to
refer to the script itself, and subsequent numbers refer to the ordered
arguments. So `$1` is the first argument after the script name.

```shell
#!/usr/bin/env bash

if [[ $1 == '--help' || $1 == '-h' ]]; then
  echo "usage: $0

Frobnicates anything needing frobnication.
"
  exit 0
fi

# The rest of the script goes below.
```


## Logging and Output {#logging-and-output}

Typically a lot of command line programs are rather silent - they don't output
much. It's totally fine though to sprinkle logging throughout your program - in
fact, for all but the most trivial programs I encourage this! But be sure to
provide a distinction between **logging** and **output**.

The [Unix philosopy](https://en.wikipedia.org/wiki/Unix_philosophy) has a lot of useful tidbits in it, but of particular note is
this item:

> Expect the output of every program to become the input to another, as yet
> unknown, program. Don't clutter output with extraneous information. Avoid
> stringently columnar or binary input formats. Don't insist on interactive input.

This flows into very practical advice for logging and your program output.


### Logging and Log Levels {#logging-and-log-levels}

Logging is the program printing out diagnostic or progress information to the
user. "Found file X", "Calling server with $URL", and "Server rejected our call
with message..." are all great things to have in your logs. Logs should always
go to `stderr` (standard error). Different languages tend to use different names
for this. Ruby's writing to `stderr` is called `warn` and Node.JS uses
`console.error`. That said, it's recommended to use a logger with log levels.
This way you can distinguish apart messages for errors, general information,
warnings, debugging statements, and so on. Most loggers can be configured to
point at a particular destination. One of those can be whatever your languages
uses for `stderr`, which is covered in your language's documentation. Logging
always goes to `stderr` so that other programs (usually shells) can use program
output without having to be aware of any kind of logging. We'll cover this more
in [Output](#output).

Additionally for logging, this sort of information can be provided via
arguments. I've seen `--debug`, `--verbose`, `--info` and other flags like this.
I don't prefer them because they are both subjective. I've seen a suite of
programs inconsistently use `--debug` and `--verbose` for the same thing, for
example. Additionally, if both `--debug` and `--info` arrive as a result of some
automation gone wonky, what happens there? Does it log `--debug`? `--info`? Does
your documentation state which one wins? Or do you put in login into the
argument handling to make sure these are exclusive arguments? I really like how
`ssh` handles it: There is a single short-hand `-v` argument for verbosity. You
can dial up the verbosity with additional "v"s. So `-vvv` is the 3rd level of
verbosity.


### Output {#output}

Output should always be printed to `stdout` (apart from logging, which goes to
`stderr`). This allows other programs (such as shells) to easily work with
output. For example, `curl` uses this pattern to much obviousness:

```shell
echo '* foo'
```

```shell
curl -k --verbose --silent https://google.com > /dev/null
```

Here, you can see all of the verbose information that curl prints - headers in
both the request and response, as well as the SSL handshake. We could redirect
that to a saved file.


## Exit Codes {#exit-codes}

Exit codes are unsigned 8 bit numbers (0-255). 0 is interpreted as success.
Everything else is a failure. These are used to not only detect failures in a
series of programs, but also determine what kind of failure.

```shell
nosuchcommand # Run a fake command to create a failure.
```

By default, shells will keep running commands regardless of failure. This can
have poor consequences.

```shell
create-report-now-please my-report.rpt # Fake command. Will fail.
# my-report.rpt was never created by the time we get here. Since there are no
# reports, this publish-all-reports command could omit any errors since there
# are no reports found to publish, or perhaps it found some reports, but just
# not "my-report.rpt".
publish-all-reports
```


### Standard Exit Codes <span class="tag"><span class="archive">archive</span></span> {#standard-exit-codes}

I need to vet this before publishing it.

There are some standards for exit codes as well.  The advanced Bash guide covers
[exit codes of reserved meaning in Bash](https://tldp.org/LDP/abs/html/exitcodes.html).  This is not quite the same as a
standard for which all outcomes could be cataloged.  Instead this gives us some
predictable outcome.

While I have found many to find this kind of thing archaic.  It's not terribly
different from how the vaunted HTTP standard works.  [HTTP codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) rain [cats](https://http.cat) and
[dogs](https://http.dog) from the standard.
