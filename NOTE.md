


Possible Optimizations
----------------------
Basically, every states are defined as `struct` with `let` properties.
Though compiler and standard libraries do some decent optimization, 
copy-elision and copy-on-write, soemtimes it doesn't work or not enough.
Then, you can try these techniques.

- Allow in-place update by making some `let` properties to `private(set)` 
  and providing some well-written mutator code.
- Make big container object convert to immutable `final class` which means
  all properties with `let`. 
- Such reference-type objects may allow `var` property and employ copy-on-
  write. 

In my speculation, big container object likely to cause some performance 
issues. Especially for dictionaries where they tend to cause more copy.
Try optimizing them to do less copying.





Use Smaller Number of Renderable Components
-------------------------------------------
For view rendering, it's quiet important keeping number of renderable 
components as small as possible. Because rendering heartbeat will be 
broadcasted to **all** of interested components. Actions can be fired up 
to 60 times per second, and it can be a problem if you have too many
renderable components. Heartbeat delivering order is undefined, so a 
view component should not depend on specific state of another component.

Anyway, you can opt-out specific range of actions in a renderable 
component, so having extra number of non-renderable subcomponent that 
are controlled by the renderable component seems to be fine.



















