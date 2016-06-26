Eonil Editor (R4)
=================

This is 4th rewriting of this app for better architecture...

Architecture
------------
TL;DR

    Data-Flow Architecture + Microservices

Current architecture is mainly based on "Dataflow Architecture" with functional style flavours.
If you're not familiar with data-flow architecture, just imagine Flux/Redux or Elm architecture. Which are most recent and 
famous implementations of data-flow architecture.

Data-flow itself alone is not very useful with aynchronous nature of modern user-facing programs. So I use microservice 
architecture to fill this gap. Microservices essentially actor-model which transfer messages asynchronously.
