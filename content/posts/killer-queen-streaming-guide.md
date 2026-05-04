+++
title = "Killer Queen Streaming Guide"
author = ["Logan Barnett"]
date = 2017-11-05T00:00:00-07:00
aliases = ["/killer-queen-streaming-guide.html"]
categories = ["killer-queen"]
draft = false
+++

<div class="ox-hugo-toc toc">

<div class="heading">Table of Contents</div>

- [introduction](#introduction)
- [changelog](#changelog)
        - [<span class="timestamp-wrapper"><span class="timestamp">&lt;2018-03-26 Mon&gt;</span></span>](#b07b0c)
- [challonge integration](#challonge-integration)
    - [workarounds](#workarounds)
- [video flow](#video-flow)
- [audio flow](#audio-flow)
- [pdx setup](#pdx-setup)
    - [facilities](#facilities)
    - [hardware](#hardware)
        - [video](#video)
        - [audio](#audio)
        - [all together now](#all-together-now)
        - [anti trip trick](#anti-trip-trick)
    - [software](#software)
        - [challonge](#challonge)
        - [kq-tournament](#kq-tournament)
        - [OBS](#obs)
- [troubleshooting](#troubleshooting)
    - [The USB webcam freezes after transmitting for a little bit](#the-usb-webcam-freezes-after-transmitting-for-a-little-bit)
    - [If the input is not recognized on the computer's end](#if-the-input-is-not-recognized-on-the-computer-s-end)

</div>
<!--endtoc-->


## introduction {#introduction}

As part of trying to reduce the Portland scene's [bus number](https://en.wikipedia.org/wiki/Bus_factor) in regards to our
streaming setup I've recorded notes here as best I can. The dream is to have a
pretty foolproof setup that anyone mildly technically competent could apply to
their scene's cab. People can and should provide suggestions and corrections so
our community can better thrive. As a general policy I won't use a comment
system on this site because static hosting is awesome and also because
[echo-chamber.js](https://github.com/tessalt/echo-chamber-js) makes an excellent point. Feel free to contact me via email,
Twitter, or carrier pigeon for any improvements we can make here.


## changelog {#changelog}


#### <span class="timestamp-wrapper"><span class="timestamp">&lt;2018-03-26 Mon&gt;</span></span> {#b07b0c}

Add changelog.
Add webcam freeze troubleshooting fix.
Add custom_ids so the export has fixed links.


## challonge integration {#challonge-integration}

Need access to Matt Wire's github repo that has a Rails server.

-   [Matt Wire's repo](https://github.com/boxofmattwire/kq-tournament)
-   [Logan's fork](https://github.com/LoganBarnett/kq-tournament)

Currently this repo isn't public.


### workarounds {#workarounds}

Changes to the Challonge setup screws up the integration with the Rails server.
The Rails server at that point can't be used (or maybe the data would need to be
wiped). At that point, the server is basically useless to us (and we shouldn't
try troubleshooting the server during a streaming run if possible). Instead
there are text files which override the blue score, blue name, gold score, and
gold name. These appear to be sources in OBS. I haven't verified this yet.


## video flow {#video-flow}

There is a 4 port splitter in cab. Two go to the two monitors. The overhead
monitor takes another slot, and the projector takes the final.

This is how our specific setup looks at PDX. Our stream box is the computer
running [OBS](http://openbroadcaster.com).

{{< figure src="/ox-hugo/video-flow.svg" >}}


## audio flow {#audio-flow}

Audio runs a weird loop. The mics wire into a mixer that runs to <span class="underline">another</span>
mixer. It's necessary for the headphones to get both the output of the computer
and the [sidetone](https://en.wikipedia.org/wiki/Sidetone) of the mics themselves. Sidetone is useful so speakers get a
sense that the system is picking up their voice, and also gives them a sense of
how loud they are being picked up.

{{< figure src="/ox-hugo/audio-loop.svg" >}}

This setup also provides lots of knobs to turn in terms of making sure the
announcers can turn up their own voices and also turn up the input of what they
are hearing from the game. This is done individually per the mixer and amp knobs
available per input/output (mixer and amp, respectively). <span class="underline">Turn the computer's
audio up to 100% and announcers can turn down as needed.</span>


## pdx setup {#pdx-setup}

This portion is specifically for the Portland setup at Ground Kontrol.


### facilities {#facilities}

Generally we need:

-   A folding table
-   A rug to cover the cables that run between the cabs and the table
-   A power strip for all of the hardware
-   A laptop with Thunderbolt support (moderately recent Macs have one or two).

Thunderbolt ports are physically compatible with Mini Display. Thunderbolt ports
can accept a Mini Display port, but it doesn't go the other way around.

A nice to have is the Thunderbolt display. It's a monitor that connections via -
wait for it - Thunderbolt. The display has a webcam, and is a rather large
screen that the commentators can easily share. It also leaves the computer free
for doing score management, enqueuing commercials or transitions, and managing
other parts of the production. Right now the Thunderbolt Display is on loan from
Day Logan.


### hardware {#hardware}


#### video {#video}

HDMI is provided as an input source via a computer's Thunderbolt port (I need to
check, but I'm pretty sure it's not mini display port). This runs from the video
splitter to the laptop.

{{< figure src="./assets/hdmi-to-thunderbolt-input-01.jpg" >}}

When the device is working, you'll see a white light near the Thunderbolt
connection.

{{< figure src="/ox-hugo/hdmi-to-thunderbolt-input-activated-01.jpg" >}}


#### audio {#audio}

Here's the amp as labeled in the diagram above:

{{< figure src="./assets/audio-4-channel-amp-01.jpg" >}}

We could use an image that's in focus...

The 4 channel mixer:

{{< figure src="./assets/audio-4-channel-mixer-01.jpg" >}}

These devices appear to be very similar, but they are very different. Basically
the mixer combines a series of inputs into a single output, and the amp splits a
single input into a series of outputs.

The mic mixer:

{{< figure src="./assets/audio-mic-mixer-01.jpg" >}}

The mics connect directly to this.


#### all together now {#all-together-now}

{{< figure src="./assets/pdx-working-setup-01.jpg" >}}

{{< figure src="./assets/pdx-working-setup-02.jpg" >}}


#### anti trip trick {#anti-trip-trick}

Ground Kontrol has seats that have these glowing strips on their corners and
sides.

{{< figure src="./assets/anti-cable-snag-trick-01.jpg" >}}

These strips slide up a little bit. There's a small channel between the strip
and the side of the seats. You can stuff some of the cables you need to run
(such as the cables for the webcams) into this channel. Here we've stuffed the
cables in there as best we can with the strip still up.

{{< figure src="./assets/anti-cable-snag-trick-03.jpg" >}}

Once the cables are in place, we can slide the strip back down, and it will hold
the cables in place well enough to prevent feet from kicking the cables out or
other snares from occurring. Here's the closed version with cables inserted:

{{< figure src="./assets/anti-cable-snag-trick-04.jpg" >}}


### software {#software}

[[]]


#### challonge {#challonge}

The URL we use is in the format `kqpdx<MMDDYY>`, where `MM` is the number of the
month, `DD` the day of the month, and `YY` is the last two digits of the year.
If today's date is <span class="timestamp-wrapper"><span class="timestamp">&lt;2017-11-30 Thu&gt;</span></span>, the URL will be `kqpdx113017`.

{{< figure src="./assets/challonge-name-01.png" >}}

Here's a list of things to clicky or type:

-   Game: killer queen
-   Single Stage Tournament
-   Double Elimination
-   1-2 Matches
-   Provide a list of participants
-   Save and Continue

Example:

{{< figure src="./assets/challonge-setup-01.png" >}}


#### kq-tournament {#kq-tournament}

<!--list-separator-->

-  installation

    Much of this is covered in the repo's `README.md`. This assumes running on MacOS
    or Linux. Windows is probably doable, but that's beyond the scope of this
    document short of someone else's contribution.

    All of the instructions below assume you're running out of a terminal. On MacOS,
    you can run `Terminal.app` for this.

    Your environment needs the following:

    -   `rbenv` or `rvm` so you can get on Ruby 2.2.3.
    -   Postgres 9.4.5.0 (greater will probably work, but the `9` is likely important.
    -   The `bundler` gem installed globally.
    -   `git`
    -   A [Github](https://github.com) account for cloning the repository.
    -   Your public ssh key uploaded to github so you can clone the repository.

    TODO: Open source the repository. Matt Wire has generously agreed to do this,
    but it needs a little cleanup.

    Clone the repository with git, and then `cd` into it.

    ```text
    git clone git@github.com:boxofmattwire/kq-tournament.git
    cd kq-tournament
    ```

    Here's an example `database.yml`. This should go in `config/database.yml`. Note
    that `username` and `password` is left out. You can add these in if you have
    accounts setup on your PostgreSQL server. The stock setup from Homebrew allows
    local connections with no credentials.

    <a id="code-snippet--kq-tournament-example-database-config"></a>
    ```yaml
    development:
      adapter: postgresql
      database: kqt_dev
      pool: 5
      timeout: 5000
      encoding: utf8

    test:
      adapter: postgresql
      database: kqt_test
      pool: 5
      timeout: 5000
      encoding: utf8
    ```

    This creates the file for you:

    ```sh
    echo "
    development:
      adapter: postgresql
      database: kqt_dev
      pool: 5
      timeout: 5000
      encoding: utf8

    test:
      adapter: postgresql
      database: kqt_test
      pool: 5
      timeout: 5000
      encoding: utf8
    " > config/database.yml
    ```

    Install all of the gems the repo uses.

    ```sh
    bundle install
    ```

    Assuming a Homebrew installed postgres, the database server is started like so:

    ```sh
    pg_ctl -D /usr/local/var/postgres start
    ```

    It can be shut down with:

    ```text
    pg_ctl -D /usr/local/var/postgres stop
    ```

    Create the initial database and its tables.

    ```sh
    bundle exec rake db:create db:migrate
    ```

<!--list-separator-->

-  running

    Once you have everything setup and the database server is running:

    ```sh
    bundle exec rails server
    ```

<!--list-separator-->

-  stopping

    Hold `Ctrl` and press `C`. This will return you to your normal shell prompt.

    Then shut down the database server:

    ```text
    pg_ctl -D /usr/local/var/postgres stop
    ```

<!--list-separator-->

-  operating


#### OBS {#obs}

[OBS](https://obsproject.com) (pronounced "awbz", short for Open Broadcaster Software) is what we use to
do streaming. Setting up streaming to Twitch is pretty simple with OBS. All
that's required is an API Key from Ground Kontrol. The API key is secret so it
shouldn't be published anywhere. This means you have to talk to staff or
ownership at Ground Kontrol in order to get it.

We still need to get a list of contacts that can provide the key.

<!--list-separator-->

-  overlays

    <!--list-separator-->

    -  chat

        <https://nightdev.com/kapchat/>

    <!--list-separator-->

    -  video sources

        I noticed my laptop struggling with the video sources when pulling in max
        resolution. I switched them to 320x200 (or close to that), and it seems to work
        much better. I suspect this is a throughput issue with 4 video sources coming in
        to one little laptop. The cameras aren't really that high res and the area of
        the screen they are displayed in is very small. There was no noticeable loss in
        quality when switching to the lower res.


## troubleshooting {#troubleshooting}


### The USB webcam freezes after transmitting for a little bit {#the-usb-webcam-freezes-after-transmitting-for-a-little-bit}

We've found unplugging from the computer's end doesn't tend to fix it, but
unplugging the USB cable from the webcam's side seems to fix it.


### If the input is not recognized on the computer's end {#if-the-input-is-not-recognized-on-the-computer-s-end}

The known recipe (not fool proof, but most of the work):

1.  Reboot the cabs with the computer's input (HDMI capture box).
2.  Reintroduce other slots (monitors x2 and the projector).
