# CONTRIBUTING

Welcome to nubjs. Use of this code, or attempting to contribute to the project,
are done at your own risk.

### FORK

It's located [on GitHub](https://github.com/nubjs/nubjs). Hopefully you can
handle it from there.

### CODE

Basically the Google style guides for
[C++](http://google-styleguide.googlecode.com/svn/trunk/cppguide.xml) and
[JavaScript](http://google-styleguide.googlecode.com/svn/trunk/javascriptguide.xml).

**Exceptions/Additions**

* Lines should always wrap at 80 characters.

* Always use [yoda conditionals](http://en.wikipedia.org/wiki/Yoda_conditions).

**JavaScript Specific**

* No nesting function declarations. Every execution path is considered hot, and
  nesting function declarations requires v8 to create a new instance of the
  function.

* No API should require the user to nest functions in order to propagate state.

* No use of `Function#bind()`.

* Variable primitives should be all lowercase and use underscores
  (e.g. `var my_str = 'abc';`).

* Objects and non-constructor functions should be camelBack.

* Constructor functions should be CamelCase.

* Any function that uses `arguments` must `'use strict'`.

* Objects remain monomorphic (e.g. no additional properties will be defined
  on an object after it has been defined).


### COMMUNITY

There are just a few basic rules for community involvement:

* Use the mailing list for technical discussion only. Discrimination, excessive
  rudeness, trolling, etc. are not tolerated.

* Address non-technical issues with other members of the community in private.

* Contact me privately if you feel another member of the community is preventing
  you from participating/contributing for reasons of discrimination. Provide
  proof of any allegations by way of chat transcripts, emails, etc.

* Using social media to vent any frustration with the project demonstrates a
  lack of desire to properly address the issue. As such, the issue will no
  longer be addressed until such time the person demonstrates they are able
  to again properly participate as a member of the community.

* No use of personal pronouns in code comments or documentation. There is no
  need to address persons when explaining code (e.g. "When the developer").
