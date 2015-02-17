NOTE
====







Goals
-----
-	Personal tasted editor.
-	Semantic auto-completion.
-	Integrated debugging.

Non-Goal
--------
-	Satisfying everyone.















Object Tree Structure
----------------------

-	ApplicationController
	-	WorkspaceDocument (multiple)
		-	WorkspaceWindowController
		-	(or) PlainFileFolderWindowController





















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








Unicode
-------

-	Unicode scalar values = Unicode code point - surrogate code







Data Reactive Style
--------------------
When you consider reactive style design, don't try to notify partial mutations. 
Because it never works. In animated UI like AppKit, it is impossible to update display immediately,
and handling frequent data mutation notification can go crazy hard.










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
-	There's no O(1) way to convert between `NSRange` and `Range<String.Index`. You have to iterate
	many the elements. Then the only reasonable solution is minimising amount of conversions.
-	Incremental conversion will be the fastest way.

Syntax highlighting and auto-completion will be fully moved into Rust side eventually. 
The problem is `NSTextView` is based on `NSTextStorage` which uses UTF-16 based text manipulation.
Rust and Swift is fully based on UTF-8, and that is right approach for modern string framework. 
(UTF-16 is somewhat outdated) 















Device Controlling
------------------
There's yet no formal way to control physical iOS devices. But here I list some possible hacks.
Always take care that these methods can't be reliable at all.

-	https://theiphonewiki.com/wiki/MobileDevice_Library#Mac_OS_X:_MobileDevice.framework

Running on device using unit-test command.

	xcodebuild test -scheme empty-app1 -destination 'platform=iOS,id=27275963caa71ef66e30165de3abeed5c164684a


















