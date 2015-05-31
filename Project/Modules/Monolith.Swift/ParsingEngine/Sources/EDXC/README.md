README
======


`EDXC` is Eonil's Data eXchange Container.
This is a specialized s-expr.
This is human readable. 
Very simple and defined strictly.
Focuses on flexibility. Not not performance.





Design Intentions
-----------------

-	Ambiguous text region cannot serve precise data transfer.
	XML/YAML fails on this. EDXC has no ambiguous part.

-	Ambiguous structure cannot serve solid data structure.
	XML fails on this. It needs complex schema to determine
	an element is value or an atom of a list. EDXC has clear
	distinction between value, list and complex entities.

-	Too complex data representation or specification hard to 
	make toolsets. YAML fails on this.

-	Any predefined data-type is useless in data-exchange 
	because you cannot fully cover all the requirements of 
	all users. JSON fails on this.


































