

Usually Cocoa view serves two different roles at once. Input and output.
It takes user input, and renders current state. Unfortunately, this is
already decided, and can't be removed. 

As a renderer, View must NOT mutate any state (Model). It can read
from model, but shouldn't mutate it. As a input processor, view must
mutate state. And we don't have a good way to grant and deny mutations
to single object. Instead, we need to separate input and output stage
in a View.

In either cases, Model should have a way to control immutability. That
means automated way to decline mutation in inappropriate stage.

Input stage is driven by user input, and model mutation should be allowed
only in this stage. We can consider another input such as timer.

A user input triggers View to handle it, and View sends it to Model.
Model mutates itself and signals mutation to observers. Observing Views
should update themselves. And in this time!, View SHOULD NOT mutate Model.
I mean while processing mutation signals from Model.

The easiest way to do this is limiting mutation channel into one. Any
model mutation will be performed by single central commander. Each model
node objects are mutated by thier own methods, but those methods are not
directly exposed externally, and external object can access them only by 
sending command. 

But anyway, eventually, a convenient extension methods will be added around
model node that just sends command. That's duplicated effotts, and doesn't
feel right. Instead, we just can check mutability flag on each mutation.





Design Goals
------------

1. Simplicity. Keep minimum abstraction.
2. Flexibility. Because we don't know the best design yet.






Implementation Strategies
-------------------------
- We do not track precise mutation events. Instead prepare views to update 
  for any state. (funtional style)
- We do not fear duplicated mutation events. Make sure views to skip such
  duplicated events.
- We DO FEAR too much code. Because our development resources are very 
  limited. Prefer slow & simple implementation over fast & complex.
- Let model node die in any state. Do not force external client to
  clean up them one by one. Instead, clean-up the model node up itself.

- Global command/event is same thing calling method on coupled graph.
  And then, prefer global notification because we don't need to track event
  source object one by one.





Why selection state are in Model?
---------------------------------
Selections are part of model as long as some other model parts require them.
Point is dependency. If the selection does not require non-model (e.g. UI)
details, it's fine to put them in models.




































