+++
title = "Graphing and Plotting"
author = ["Logan Barnett"]
aliases = ["/graphing.html"]
draft = false
+++

<div class="ox-hugo-toc toc">

<div class="heading">Table of Contents</div>

- [introduction](#introduction)
- [reading material and citations](#reading-material-and-citations)
- [plot](#plot)
- [ob-gnuplot](#ob-gnuplot)
    - [reset](#reset)
    - [separator](#separator)
    - [dates](#dates)
    - [working example](#working-example)

</div>
<!--endtoc-->



## introduction {#introduction}

`org-mode` supports graphing with `gnuplot`. This can be done directly with
`#+plot` but it's very rudimentary. It can also be done with `org-babel` and I
can still feed tables into it.


## reading material and citations {#reading-material-and-citations}

[ob-gnuplot docs](http://orgmode.org/worg/org-contrib/babel/languages/ob-doc-gnuplot.html#orgfbe3a85)
: Has lots of good examples for `gnuplot` via `ob-gnuplot`.

[org-plot docs](http://orgmode.org/manual/Org_002dPlot.html)
: `org-plot` documentation. Examples feel sparse for my simian
    mind.

[org-plot tutorial](http://orgmode.org/worg/org-tutorials/org-plot.html)
: And has [the org mode version](http://orgmode.org/worg/org-tutorials/org-plot.org) I can use as reference.

[Plotting (with gnuplot) using dates timestamps](https://lists.gnu.org/archive/html/emacs-orgmode/2012-03/msg01019.html)
: Mailing list discussion
    showing how `org-timestamp` columns get converted to another format.

[gnuplot documentation](http://www.gnuplot.info/documentation.html)


## plot {#plot}


## ob-gnuplot {#ob-gnuplot}

`ob-gnuplot` is the `org-babel` approach. It's much more powerful but much more
explicit. Basically it allows expression as pure `gnuplot` code.


### reset {#reset}

The `*gnuplot*` buffer is basically a repl for `gnuplot`. In order to ensure
settings don't bleed over between evaluations, use `reset` to make sure prior
runs don't influence the current run.

```gnuplot
reset
```


### separator {#separator}

Tables fed to `gnuplot` are tab separated. Set this to properly distinguish
columns apart from each other.

```gnuplot
set datafile separator "\t"
```


### dates {#dates}

Dates are harder to work with. There's a few `gnuplot` settings that are just a
given with dates/times. The dates provided by `org-timestamp` are converted to
the format `YYYY-MM-DD-hh:mm:ss`. The hours, minutes, and seconds are all always
"00". This is determinable by looking at the `*gnuplot*` buffer, which will show
a temporary path where the file will be emitted such as
`/var/folders/2g/7v48qrcn2nqgm9_dl173mhd80000gn/T/babel-3445j1/gnuplot-344q9h`.


### working example {#working-example}

"Real" data!

<a id="table--example-data-01"></a>

| time                                                                                         | ufo sightings | taylor swift songs produced |
|----------------------------------------------------------------------------------------------|---------------|-----------------------------|
| <span class="timestamp-wrapper"><span class="timestamp">&lt;2010-12-16 Thu&gt;</span></span> | 1             | 45                          |
| <span class="timestamp-wrapper"><span class="timestamp">&lt;2012-12-16 Sun&gt;</span></span> | 2             | 24                          |
| <span class="timestamp-wrapper"><span class="timestamp">&lt;2014-12-16 Tue&gt;</span></span> | 6             | 12                          |
| <span class="timestamp-wrapper"><span class="timestamp">&lt;2016-12-16 Fri&gt;</span></span> | 30            | 5                           |
| <span class="timestamp-wrapper"><span class="timestamp">&lt;2017-12-16 Sat&gt;</span></span> | 50            | 3                           |

```gnuplot
reset
# org-babel passes gnuplot a payload that's tab separated.
set datafile separator "\t"
set xdata time
set xlabel "time"
set yrange [0:]
# This is the format that org-babel sends to gnuplot.
set timefmt "%Y-%m-%d-%H:%M:%S"
set xrange ["2010-12-03-00:00:00":]
set format x '%Y-%m-%d'
set xtics format "%b %d"
# 564 is the magical width of 80 columns at the present font settings.
set term png size 564, 400
plot data u 1:2 w linespoints title 'ufo sightings', \
     data u 1:3 w linespoints title 'taylor swift songs produced'
```
