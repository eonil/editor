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













Architecture
------------

Each component exposes its feature publicly with minimum dependency.
Caller can use them as is. 

There's a component called "Model". That provides a central organised
storage, and orchestrates inter-component mutation dependencies. So,
final application just uses model.

A newrly added component can be used as is basis until I feel it to be
integrated into central model.



Resource Management
-------------------
OBJC/Swift is RC based. That means RAII does work, but only for memory 
management. For any other kind of resources, you must manage them all 
just MANUALLY.

This is mainly due to early nil-lization of weak references. You must
initialization/termination of all non-memory resources yourself 
manually. Here're the rules.

-	If a resource is acquired in `init`, it must be reliquished
	in `deinit`.

-	If a resource is acquired after `init`, it must be reliquished
	BEFORE `deinit`. Object should not `deinit` while it holds 
	those resource.









Menu Handling
-------------

-	Uses custom menu controller pattern. See `ProjectMenuController.swift` for how it works.
-	This is applied only to dynamic menus. Static menus are currently implemented using an NIB.
	This will be removed later.











File System Watching
--------------------
`NSFilePresenter` simply does not work as advertised, and Apple has no
interest on fixing it. It's been abandoned at least last 4 years, and 
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

Swift is designed to be better with eager evaluation, but Objective-C layer does not play well with
eager-evaluation design pattern. So make it to be instantiated lazily in most cases.



-	`NSString` simply contains UTF-16 code units. (http://www.objc.io/issue-9/unicode.html)
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






Boilerplate Conventions
-----------------------
-	Most view classes are consist of these boilerplate functions.

		_install()	//	Configures view/data structures.
		_deinstall()		
		_connect()	//	Configures event signaling systems.
		_disconnect()


`~View`, `~Piece` and `~UI`
---------------------------

"View" means just plain AppKit view class that follows AppKit's method/delegate convention
for signal in/out. It's independent component, and is not tied to any other part of the
application.

"Piece" is just a kind of view that uses `SignalGraph` facilities for signal in/out.
Usually this is wrapper of a view to provide unified signaling method.

"UI" is a specialized view (or view controller) that is tied to global application state 
tree. So it is globally coupled with application state completely. Accepts application 
global state tree, and handles all signal in/out by itself.

Usually, I make a view or piece that handles a proper interaction, and use them as 
components of a `~UI` to connect them to application state. Consequently, "View" or "Piece" are 
usually generic component, and "UI" is always a fully specialized concerete classe.























Terms
-----

-	State: A value at a timepoint.
-	Identity: Referenceable and reference equality comaprable.
-	Controller: "state" + "identity".




