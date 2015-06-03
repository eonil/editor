NOTE
====
Hoon H.








For Maintainers
---------------
There're two types of tests. One is *internal*, and the other one
is *external*. External test is plain old unit-test. Uses Xcode 
provided test features. This is fine, but there're corner cases.

-	Dependent test. Some tests are logically dependent to each 
	other, and cannot be done in rando order. 

-	Testing internal/private-only features.

Internal test is just a plain executable target which runs these
kind of tests. Usually internal test written to prove logical
integrity of internal features, and external tests are written to
prove whether the features exposed via public API are working 
properly or not.

Write internal tests just beside of the feature. It's recommended
put them in same file where the feature is. Internal test classes
must be set to `internal` access level, and shouldn't be exposed 
publicly to be eliminated by compiler optimisation.