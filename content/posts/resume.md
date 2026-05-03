+++
title = "Logan Barnett's Résumé"
date = 2021-09-06T00:00:00-07:00
aliases = ["/resume.html"]
draft = false
+++

---
layout: default
title: Résumé
date: 2020-01-13
categories: software-engineering
---

<link rel="stylesheet" type="text/css" href="resume.css" />


## Contact {#contact}

-   Email: [logustus@gmail.com](mailto://logustus@gmail.com)
-   Mobile: 602.264.3584
-   Blog: <https://loganbarnett.github.io/blog/>
-   Github: <https://github.com/loganbarnett>

This document was generated from:
<https://github.com/LoganBarnett/blog/blob/gh-pages/resume.org>


## Summary {#summary}

I've been a professional software engineer for 22 years.
I've worked on video games, embedded devices, web applications, desktop
applications, and managed server infrastructure. I prefer a sustainable approach
to software development and maintenance alike. I enjoy providing guidance and
tackling difficult problems. I feel good and functional documentation is the
road to well maintained and understood software.


## Job Experience {#job-experience}


### Houghton Mifflin Harcourt (HMH, formerly NWEA) (2023-current) {#houghton-mifflin-harcourt--hmh-formerly-nwea----2023-current}

Alchemy had to close its doors.  I'd left NWEA better than I'd found it, and
they were happy to have me back.  I resumed work at the DevOps team.

1.  I took over our Environment Down Days process, which took about seven
    engineers working full time for 3 days to accomplish, down to 1-1.5 days of a
    single engineer.
2.  Provided guidance to many new engineers on how to work with our Puppet
    ecosystem, keep systems operational, and build out further automation.
3.  Moved many systems to CICD, generally via Ruby gems (a legacy stack), Docker
    images, and Jenkinsfiles.
4.  Leveraged LLMs to troubleshoot, make code edits, and a automated basic
    mundane tasks using MCP.


### Principal Instructor at Alchemy Code Lab (2022-2023) {#principal-instructor-at-alchemy-code-lab--2022-2023}

1.  Instructed at a code camp to help students learn various software engineering
    practices.  Some things I helped teach:
    a. Type safety.
    b. Data structures and Algorithms.
    c. Complex state management in React.


### NWEA (2016-2022) {#nwea--2016-2022}

At NWEA I have worked at several teams (typical for the org) and formed many
cross team connections. I was primarily hired for JavaScript and Angular.js
experience but dipped into many other disciplines.


#### DevOps {#devops}

Joined DevOps team to help with in-house infrastructure applications and tools.

1.  Assumed stewardship over all of our in-house applications which controlled
    the colo, managed deployments, managed release planning, and credential
    synchronization. All programs enjoyed improvements over reproducible builds,
    better tests, memoized API calls, and automatic deployments to keep them
    working in a rapidly changing ecosystem.
2.  Provided significant direction for Build Engineering sub team to help
    consolidate a wide spread of tech employed. One example is consolidating all
    of our Jenkins build agents into the Cloud Swarm - a flexible pool of
    Dockerized Jenkins agents.
3.  Maintained and automated much of the Nomad (scheduling) infrastructure.
4.  Brought perspective to the team who don't have to consume their tools the way
    the engineering teams have to.


#### Assessment {#assessment}

Senior engineer spearheading new proctor interface.


##### Summative Proctor UI {#summative-proctor-ui}

Built a React-Redux user interface for proctoring (running) student tests.

Powerful tests
: The UI used algebraic data types with Flow instead of
    ordinary unit tests. Automated tests are Cucumber + Nightwatch.js to pilot a
    browser using tests that relatively untrained QA members could contribute to.
    Achieved 100% type coverage, and 350+ acceptance test scenarios.

Automatic Swagger synchronization
: Mocks were kept in sync with the Swagger
    definitions, and all data was sanitized at virtually no cost. The UI
    oftentimes was the insurance that APIs stayed true to their contract.

Deployment
: Helped create a Feature flag system allowed features to be
    overridden by QA, to be deployed immediately yet turned on at a predetermined
    time. Closest application to the organization's ongoing CICD efforts.

Collaboration
: Worked closely with other teams to ensure smooth cross
    communication between UI and severs. Ongoing org assistance and worked on
    shared projects such as the style guide.


###### JavaScript technologies employed {#javascript-technologies-employed}

-   Helped with Webpack setup on the style guide.
-   Setup CSS Modules in the style guide, and educated on their usage.
-   Presented Angular-React demo + PR to show we don't need to write shared
    components for both Angular and React.


#### Item Experience {#item-experience}

Senior Engineer providing JavaScript expertise.


##### Build and deployment {#build-and-deployment}

Streamlined a manual build and deploy process.


##### Babel {#babel}

Implemented Babel transformations for a critical backend Node.js service.


#### OECD {#oecd}

Senior Engineer serving as Angular and Javascript expertise needed by the team.

1.  Migrated the administration portion of the project onto Webpack.
2.  Created unit testing pattern that is easier to maintain and author.
3.  Helped significantly improve the Protractor.js test stability, including
    implementing custom waits for CSS animations, and drawing on screenshots as a
    means of debugging failing tests caused by obscured objects the tests were
    trying to click on.
4.  Created script to serve as a first pass at converting all hard-coded strings
    inside of Angular templates into i18n version, and storing the English
    translation with a friendly lookup name.


#### UX/UI organizational needs {#ux-ui-organizational-needs}

Ongoing company assistance and work on shared projects such as the style
guide.

1.  Helped with Webpack setup on the style guide.
2.  Setup CSS Modules in the style guide, and educated on their usage.
3.  Presented Angular-React demo + PR to show we don't need to write shared
    components for both Angular and React (the org uses both in different
    teams).
4.  Assisted UX team in making more semantic styling.
5.  Acquired and provided accessibility (a11y) expertise.


### IT-Motives -&gt; UTi -&gt; DSV (2014-2016) {#it-motives-uti-dsv--2014-2016}


#### Client Portal {#client-portal}

Senior Engineer leading the UI of Client Portal at UTi and
providing expertise for Angular.JS.

1.  Restructured the AngularJS app to take on a larger scale of UI.
2.  Implemented caching for values that rarely change.
3.  Educated team on quirks of Javascript and AngularJS.
4.  Migrated the team to TDD and got the UI up to 100% test coverage.
5.  Provided advice for other teams at UTi as they considered taking on.
6.  AngularJS as a UI framework.
7.  Setup Jenkins for automated CI and test coverage reporting.
8.  Setup Cucumber testing to make executable business requirements.


#### Identity Management {#identity-management}

Lead engineer on company-wide self-user-management app.

1.  React + Redux in a functional style.
2.  Highly test driven.
3.  Webpack, ES6, Browser-sync, CSSModules.
4.  Interfaced heavily with Oracle's security stack.
5.  Intended as a pilot project for React for upgrading legacy projects
    piecemeal.


### Arizona State University -&gt; E-Line Media (2011-2014) {#arizona-state-university-e-line-media--2011-2014}


#### AtlantisRemixed {#atlantisremixed}

Co-lead/senior Developer to make a game series to eventually become an MMO.

1.  Developed integrated logic system for game designers to code without heavy
    coding knowledge.
2.  Designed build system and significant portions of the patching system.
3.  Optimized level loading, character composition, and editing tools all built
    in Unity using .net.
4.  Integrated game with a Ruby on Rails web stack.
5.  Managed small team of software developers.
6.  Managed Scrum/Agile process.
7.  Continued working remotely with team when I moved to Portland with a good
    deal of success.


#### E-Line Publishing Platform {#e-line-publishing-platform}

Software Engineer assisting in construction of an MMO game engine.

1.  Continued support of Atlantis Remixed project from ASU partnership.
2.  Implemented Action-Condition-System - a server side game logic editing
    system for game designers.
3.  Implemented dialog system and later extended it to also be a web authoring
    tool.
4.  Implemented distribution system that interfaces with JMS for providing
    realtime communication.
5.  Designed and built in-game UI using Angular.JS and fed it data via a
    socket server.


### GoDaddy Inc (2010-2011) {#godaddy-inc--2010-2011}


#### Hosted Exchange {#hosted-exchange}

Providing Exchange as a hosted/shared solution.

1.  Maintenance and enhancements to a Legacy .net app.
2.  Extensive work with Powershell to work closely with Exchange 2010.
3.  Created support tools using MVC3.


### Integrum Technologies (2009-2010) {#integrum-technologies--2009-2010}

Worked as a Rails developer and did extensive pair programming.


#### On the Record Sports {#on-the-record-sports}

Backend to a fantasy sports app that used SportsDB feed.

1.  Consumed complex JSON services
2.  Worked very closely with client as main contact remotely using Skype and
    company’s Scrum/Project tracking software


#### 7th Day Adventists {#7th-day-adventists}

Customizable sites that can display different kinds of content based on
extensions installed.

1.  Worked on a legacy Rails app with thousands of users
2.  Improved the existing custom deployment scheme
3.  Worked with various users on bugs


#### Valley Metro {#valley-metro}

Public bus schedule system for seeing when/where busses run.

1.  Imported data from their system using background processes.
2.  Displayed route info using their CSS and layout.
3.  `a11y` compliance.


### Happy Camper Studios (2007-2009) {#happy-camper-studios--2007-2009}


#### Skywire Interface {#skywire-interface}

Manages settings and shows diagnostics for satellite modems.

1.  Managed relationship with business's primary contact - Radyne (now Comtech).
2.  Desktop application with many forms (20+).
3.  Utilized SNMP4J to communicate with modems over the SNMP protocol.
4.  Installers written for Windows, Linux, and OSX.


#### Claim Tracker {#claim-tracker}

Manages clients and phone script/history for tracking problems with claims.

1.  Managed relationship with business's secondary client - New Haven Dental
2.  Built the initial version of the application using Monkeybars.


#### JotBot {#jotbot}

Happy Camper Studios' product.

1.  Main contribution was against the export feature (CSV, XML, PDF)


### UHaul International (2004-2007) {#uhaul-international--2004-2007}

Entry level software engineering position.


#### Claim Center {#claim-center}

Tracked and processed claims (UHaul is self insured).

1.  SOAP web services and .net remoting.
2.  Bridged Java-based system with existing .net infrastructure


#### Hitch Central {#hitch-central}

Handles ordering of new hitches and manages hitch inventory.

1.  .net desktop client


## Proficiencies {#proficiencies}

This is my obligatory buzzword list.


### Languages {#languages}


#### Javascript {#javascript}

React, Redux, Three, Angular, Node, ES6, Webpack, Flow, npm, yarn.


#### Java {#java}

Swing, JAX-RS, JRuby, JUnit, SNMP4J.


#### .net {#dot-net}

C#, Boo, Unity/Mono, MVC, WCF, NUnit, OData, Powershell.


#### Ruby {#ruby}

Ruby on Rails, Sinatra, JRuby, Cucumber, RSpec.


#### Rust {#rust}

Actix, futures, abstract data types, monad chains, and avoiding `unwrap` ;)


### Databases {#databases}

MongoDB, MySql, SQL Server, Oracle + PL/SQL.


### Misc {#misc}

Jenkins, JIRA, Pivotal Tracker, Trello, git, Perforce, svn, hg, Plastic SCM,
vim, emacs, literate programming, functional programming.


## Side projects {#side-projects}

1.  [This résumé](https://github.com/loganbarnett/blog/tree/gh-pages/resume.org) - Uses `org-mode` document and `jekyll` to generate an HTML
    based résumé.
2.  [roid-miner](http://roid.logustus.com:9000) - A generated asteroid mining game with a powerful editor for
    composing asteroid generators in real time.
3.  [Lambda Cast](https://soundcloud.com/lambda-cast) - I costar in a podcast about function functional programming.
4.  [My own dotfiles](https://github.com/LoganBarnett/dotfiles) - If we value infrastructure as code, why not for our local
    machines? Also contains my Emacs configuration.
5.  A few literate programs: [40k-dps](https://github.com/LoganBarnett/40k-dps), [airbrush-dias](https://github.com/LoganBarnett/airbrush-dias), [typedef-gen](https://github.com/LoganBarnett/typedef-gen).
6.  [flow-degen](https://github.com/LoganBarnett/flow-degen) - Generate typesafe validation/deserialization JavaScript code.
7.  [cubed.js](https://github.com/LoganBarnett/cubed.js) - A library to help me work on my voxel game.
8.  [runner](https://github.com/LoganBarnett/runner) - My attempt at making a Rust command line replacement of
    Alfred/Quicksilver.
9.  [jj](https://github.com/LoganBarnett/jj) - Run Jenkins jobs from the command line and see the output. Rust.
10. meta-game - And editor using React + Redux + Three used for creating games
11. Various Unity games - Writing desktop/mobile games using Mono + C# and Boo
    (.net 3.5).
12. Monkeybars - MVC desktop GUI framework using JRuby and Swing.
13. Jemini - 2D game framework for JRuby.
14. Rawr - A packaging system creating double clickable app bundles for JRuby.


## Education {#education}


### DeVry University {#devry-university}

Graduated 2004 with BS in Computer Engineering Technology
