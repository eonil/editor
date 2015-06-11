EditorModel
===========





Design Policy
-------------

1.	Subcomponents do not mutate owner state.
	Though subcomponents are tightly coupled with owner in type system,
	its mutation behavior should not. Mutate in owner by observing signals
	from subcomponents.
	
