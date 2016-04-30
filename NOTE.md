


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