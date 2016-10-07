Eonil Editor (R4)
=================

**BUILD BROKEN** I didn't know, but one very important file was been missing in repo...


This is 4th rewriting of this app for better architecture...

Architecture
------------
TL;DR

    Data-Flow Architecture + Microservices

Current architecture is mainly based on "Dataflow Architecture" with functional style flavours.
If you're not familiar with data-flow architecture, just imagine Flux/Redux or Elm architecture. Which are most recent and 
well-known implementations of data-flow architecture.

Data-flow architecture alone is not very useful with aynchronous nature of modern user-facing programs. So I use microservice 
architecture to fill this gap. Microservices essentially actor-model which transfer messages asynchronously.



Design Decisions
----------------
Optimized for faster code writing.

- Driver exposes each services directly.
    Tried to hide them and expose only dispatch methods, but I think that just brings one more extra layers to code.
    Anyway, I can hide them again easily if needed. No worries.

- Many services now accepts dispatching of functions.
    Here're some points.
    (1) For referentially-transparent state with pure-function mutators, we don't need to return a value because everything can 
    be calculated equally before dispatching action to mutator.
    (2) If the processing involves any impure operation, it usually need to return some value, and type of this value is usually
    different by processings.
    (3) Asynchronous operation doesn't have to be impure, but we have to assume them impure because anything can happen, and we
    need to be defensive. If an asynchronous operation involves any external I/O, it is impure by definition.
    (4) "Terminal" operations -- which doesn't need to continue to another operation -- don't need return value. But this is
    pretty exceptional case.
    Then "ideal" solution is using pre-value based action dispatch interface for purely functional state and mutators, and using 
    function interface for any impure services. Anyway, I decided to prefer function interface at least for now.
    Pure-value-only dispatch sounds cool, but it take too much time to "design" such actions.
    

Legacy
------
R3 (legacy) has been [archived](https://github.com/eonil/editor/tree/7b858e22697e109d9f5cf84314fdbe1cb04307fb).

License
-------
MIT license.

















     
