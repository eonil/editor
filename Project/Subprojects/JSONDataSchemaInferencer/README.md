JSONDataSchemaInferencer
========================
2014/11/16
Hoon H.



Inferences data schema from multiple JSON data samples.





Algorithm
---------

1.	Prepare a *path* which can describe any value at any location.
	In my case, I desribed it using field name and array index.
2.	Iterate all objects, arrays and *values*. 
3.	Collect all of thier paths.
4.	Extract paths for composite type values. 
5.	Extract its field paths.

Now you have composite types and its fields. Everything is prepared.








A Little More Explanation
-------------------------

Because JSON does not denote types, `JSON Object` is actually an
anonymous tuple with named fields. I sorted every values based on
tuples.

Array indexes are ignored, and all arrays at same location will be
treated as homogeneous arrays. All subpaths of all elements will be
merged.

Tuple is unnamed, then the name of tuple is set to its path without
array indexing. This equals to conatenated field names to the object.




Caveats
-------
This is nothing related to ["JSON Schema"](http://json-schema.org) 
thing. This does not use any of that stuffs. (maybe layer!)

This is inference. Does not provide precise schema. This program is
designed just to help initial data class design, and you shouldn't
be fully rely only on this because schema can be wrong if there's
undiscovered data.

API writers. Please! Provide full data schema for all of input and 
output! Just an example output can't be enough. It's something like
a library without function signature and refernce manual AT ALL!!!
Binary only library huh? If you don't provide precise schema, your're 
a selfish idiot who can't even imagine position of peer developer.









License
-------
Copyright © 2014 Hoon H..
Licensed under MIT license.