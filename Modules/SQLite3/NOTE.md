NOTE
====




On Design
---------

-	Acepting error handler as an extra input parameter is not a good idea.
	It needs a mutable state update to check the error, and requires tracking
	of separated execution context. Instead, this library returns error enum
	information for features require returning errors. Note that there's no
	result on error situation, so it returns an enum. Implementation is 
	`Error<E,V>` enum.





Layers
------

-	Low-Level means C-interop layer. No logics or abstractions, just handles
	interfacing and type conversions.

-	Mid-Level means exposing SQLite3 features as is. Query builder is provided
	for your convenience. Low level is fully hidden.

-	High-Level means extra abstraction for best convenience. Instead, this is
	very limited in features. Mutator mid/low levels are fully hidden not to 
	break abstraction, but some mid-level features are exposed for read-only
	operations.

You can choose any level what you want to use, but you can't mix them. Once 
established connection to a database file can be manipulated using only with 
the type of the connection.






Lifecycle Management
--------------------
Low-level layer uses fully manual memory management. Though they're RCed objects,
you need to open/close each object manually.

Mid-level layer uses strict unique ownership manner. Super object owns subobject,
and you need to keep a strong reference to the superobject to make subobjects 
alive. This organised a tree graph.

High-level layer uses automatic semantics. Subobjects may retain superobjects to
extend thier lifetime automatically. Cycles are avoided by retaining subobjects 
as a weak/unowned. 

	Database owns TableCollection, but not Table.
	Table owns Database, but not TableCollection.

	Program, Execution, Selection, List, Page all owns thier origin objects.









