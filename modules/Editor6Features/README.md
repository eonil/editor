Editor6Features
===============
Hoon H.




Transition Form
---------------
Sometimes you need to track "how" state has been changed.
This sounds imperatively, but unavoidable destiny.
But, such "how" information is temporal, and cannot be
provided without temporal parameters. (such as remove indices)
And providing temporal parameter isn't a good idea because such 
temporal parameter is usually context-dependent. For instance,
"removed index" sounds good enough, but you MUST guarantee
your current consumer has a certain state (prior snapshot).
Provision of this kind of guarantee making writing program
very hard and should be avoided.

Here's my solution. Describe a "transition" instead of 
"snapshot". You lose such temporal informations because you
store only "snapshot"s. Just add "how" information. How it's
been changed.

Transition state is build with 3 components.

- Old state.
- How it's been changed.
- New state.

Old state is provided to make state context-free. Data 
consumers don't have to be in a "specific state" to process
transition information. It can just discard any existing 
information and render the transition from old state to
new state. 

* Note: Of course, if you can perform equality comparison
    quickly, you can optimize this by rendering only deltas
    instead of full re-rendering.
