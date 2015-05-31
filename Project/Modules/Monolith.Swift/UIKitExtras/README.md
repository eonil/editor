UIKitExtras
============
2014/11/19
Hoon H.




Provides clear and convenient anchor based auto-layout utilities.
This does not fully cover all of autolayout-constraint semantics. Provides only most frequently used stuffs.






How to Use
----------

Here's an example.

	self.addConstraintsWithLayoutAnchoring([
		authorLabel.topAnchor				==	self.topAnchor,
		downloadCountLabel.bottomAnchor		==	self.bottomAnchor,
	], priority: 750)

This makes `authorLabel`'s top border to be attached to `self`'s top border.
Also makes `downloadCountLabel`'s  bottom border to be attached to `self`'s botto border.

You also can put some displacement by adding `CGSize`.

	self.addConstraintsWithLayoutAnchoring([
		authorLabel.topAnchor				==	self.topAnchor + CGSize(width: +100, height: -100),
		downloadCountLabel.bottomAnchor		==	self.bottomAnchor,
	], priority: 750)

Please note that this is not all operators are supported. Only addition of `CGSize` is supported.
Operation is intentionally limited to make it simple. Anyway I will consider to support another
operators if I feel need for it.

Priority 750 is recommended. Priority 1000 (maximum value) means the app will be crashed 
rather than hiding some portion of the target views if the constraints couldn't be satisfied.
That's not pretty desired behavior in most cases...

Here's another example.

	view1.addConstraintsWithLayoutAnchoring([
		view2.centerAnchor	==	view3.centerAnchor,
		view2.sizeAnchor	<=	view3.sizeAnchor,
	], priority: 750)

This makes `view2`'s center will be attached to `view3`'s center.
And limits `view2`'s size to be equals or smaller than `view3`'s size.



















License
-------
This follows `Monolith.Swift` framework licensing terms that is MIT license.