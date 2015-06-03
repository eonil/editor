Monolith.Swift
==============
Hoon H.



Monolithic collection of multiple features in Apple Swift.
Written by Hoon H..

In my opinion, Swift tends to separate each features into smaller modules 
rather than a big one module. I separated each featuers into 
small projects, and you can use only features that you want. 

Each subprojects are defined as modules. So you need to `import` them one 
by one to use their features. For example, if you want to use "UIKitExtras", 
then `import UIKitExtras`.

This is just a rough outlines. See each sbproject's README for details 
like how to use them. See code documentation for ore details.








`Standards` Features (Full Implementations)
-------------------------------------------

-	RFC 3339 timestamp scanning and printing. (Pure Swift)
-	RFC 4627 JSON scanning and printing. (Cocoa inter-op)

ISO 8601 is avoided in favor of RFC 3339.




`Standards` Features (Partial Implementations)
----------------------------------------------
These features are implementation of very small portion of a large 
standard.

-	RFC 1866 HTML form encoding for URL query-string.
-	RFC 2616 Predefined HTTP method constants. (Pure Swift)



`Dispatch` Features
-------------------

-	Convenient and native feeling wrapper of GCD functions for Swift.


`UIKitExtras` Features 
----------------------

-	Anchor based auto-layout constraint builder.
-	Many extensions to UIKit classes for convenience with Swift.




`AppKitExtras` Features 
----------------------

-	Basically same with `UIKitExtras`.




`CancellableBlockingIO` Features 
--------------------------------
This is suspended, and likely to be deprecated soon.
Because blocking vs non-blocking really doesn't matter here, and 
non-blocking form plays better with Apple SDK because it is fully 
written in non-blocking form.



`Text` Features 
---------------
Provides functional parser combinators. Anyway, I am not sure on
usefulness of this feature. So it is currently suspended.











License
-------
MIT license.

