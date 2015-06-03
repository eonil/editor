











Well-Formness
-------------
This has only two data types; text and list.
Text data type can be represented in two forms; symbol and literal.
This is soley for 
List can be empty to represent nil.
There's no implicit conversion between atom and list.

Foundational unit is `<name> <type> <expression>` triplet.
Each part can be any of type/forms.

	(() "ABC" 234)
	(123 () "dwdw")
	("AS" 124 ())

Each parts are separatd by whitespace characters. If you want to
write whitespace character in data, you must use backslash-escape
or string literal.



Data Tree Semantic Profile
--------------------------
Focuses on human readability. Bare form is hard to read if data becomes 
complex. This profile limits possible forms/types for each part. 

-	`<name>` must be text in symbol form or nil.
-	`<type>` must be text in symbol form.
-	`<expression>` can be text in literal form or nil. But not text
	in symbol form.

Though you can use any Unicode characters in symbol form, but I
don't recommend to use everything. For data exchange, it's better
to limit possible character set to common program identifiers.







Example
-------
Here're some simple values.

	(Slot1 String "Hello!")
	(Slot2 Integer "42")

If you don't want a `<name>`, it can be ommited by using empty
list which means nil.

	(() Integer "42")

Only `<name>` can be nil. `<type>` and `<expression>` cannot be
nil.

`EDXC` does not define how to parse expressions. Expression
is just a string-literal, atom or list. Proper parsing of the string
is fully up to how user handles the <type> symbol.

	(() URL "http://EDXC.com")
	(() HTML "<html><head/><body/></html>")
	(()	Javascript "var a = function(){ return 42 }")

Expression can be anything. Anything added at the end are all treated
as <expression>. Then, atoms in `[2:]` range are actually the expression.

	(() SymbolList Integer String Boolean)
	(() StringList "Hello," "World!")
	(() IntegerList "1" "2" "3")
	(() IntegerStringPairs "1" "A" "2" "B" "3" "C")

The whole expression part will be passed to data parser, and parser
is fully responsible to how to deal with it.

A complex object can be presented using another units as expressions.

	(() 
		Type1
		(field1 String "value1")
		(field2 Integer "999")
		(field3 
			Type2
			(field4 Integer "1024")
			(field5 Boolean "true")
		)
	)
	






	








	

