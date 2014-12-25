NOTE
====























File System Watching
--------------------
`NSFilePresenter` simply does not work as advertised, and Apple has no
interest on fixing it. It's be abandoned at least last 4 years, and 
relying on it seems to be very dangerous. Also it has some hidden and
complex threading behavior, and it's almost impossible to deal with it.

`kqueue`/GCD based file-system notification approach does not support
notification of subdirectory, then it needs complex tracking. So it's 
been avoided.

Then the only remaining option is `FSEvents`. This is why I am using it.













Rust Resources
--------------

-	`crates.io` API

	The front-end is built with Ember.js, then everything is provided
	transparently. For example, this command;

		curl https://crates.io/api/v1/crates

	For pretty-printing, use this command.

		curl https://crates.io/api/v1/crates | jq .

	will provide nice JSON output, and the data schema can be found 
	from [crates.io source code](https://github.com/rust-lang/crates.io).
	

	Routing is defined in this file.
	
		https://github.com/rust-lang/crates.io/blob/master/src/lib.rs

	Actual features and data-types are defined here.

		https://github.com/rust-lang/crates.io/blob/master/src/krate.rs

	It's far nicer than another typeless APIs :)















Handling Cocoa
---------------
Whole AppKit is written in **fully** lazy-evaluation philosophy.
When you're subclassing a Objective-C based Cocoa class always make everything
to be lazy-evaluated. Make every field to be instantiated laily. Especially AppKit
UI classes. Otherwise they usually break.

Usually these are signs that something is going wrong.

-	You need to override initialisers* of `NSView`/`NSViewController`/`NSWindowController` 
	family classes. 

-	You assign a instance variable field value directly at initialisers. (including `let` assignment)

Swift is designed to be better with early evaluation, but Objective-C layer does not play well with
early-evaluation design pattern. So make it to be instantiated lazily in most cases.



-	`NSString` is simply contains UTF-16 code units. (http://www.objc.io/issue-9/unicode.html)







