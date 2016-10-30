WorkspaceModel
==============
Hoon H.




Model translates user command into a serial list of functions.
Those functions will be passed to a delegate to be processed
at PRECISE timing.

So basically, every operation on model is asynchronous. There's
no synhcronous operation.

When you maintain this, keep models divided by data domains,
not feature.



***VERY IMPORTANT!!!***

You MUST use `WorkspaceModelMessageLoop`. DO NOT try to process
model notifications yourself unless you becomes very familiar
with overall architecture of this program.










