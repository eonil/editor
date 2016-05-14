Eonil Editor (R4)
=================

This is 4th rewriting of this app for better architecture...

Architecture
------------
This program is being written in *FRP (Functional Reactive Programming)* architecture. Which means state is represented
in pure value tree, and each loop iteration creates whole new set of state for each time. And rendering
of the state always produces same result for same state.

Honestly saying, this is not truly "purely" FRP. Because reality if not ideal. 
- Cocoa is typical impure object-oriented framework. Sometimes does not play well with FRP.
- External environment affects.
- We need good-enough performance.
But anyway, I do not cross the minimum line. That is *immutable state stream*. Program state is completely represented in 
immutable state stream. Anyway due to above limitations, sometimes rendering can be a bit awkward. Because AppKit doesn't fit
very well to FRP paradigm. Sometimes AppKit views maintain their own states, and such internal states make impossible rendering 
fully in FRP manner. I had to deal with this, and compromised with reality. Which means "eventual rendering". Regardless of how
state is configured, view works independently from the state, and can be out-synced from state. Anyway view will try to be
in-sync as quickly as possible.

FRP is getting popular nowadays. You can find many FRP based architecutres. For example, 
[Elm](https://github.com/evancz/elm-architecture-tutorial) and 
[Redux](https://www.google.com/search?client=safari&rls=en&q=redux&ie=UTF-8&oe=UTF-8).
If you're familiar with one of those architectures, you'll find similar stuffs in this program too.


