







Lifecycling
-----------
Model exists independently from UI. Then it will never be affected by UI.
When you write model code, do not consider UI lifecycling.

UI depends on model. Each UI component that consumes model always have 
`weak var model: T` property, and model will be assigned at here. 

All UI components should have explicit concept of session start/end. For
`NSView` classes, it's recommended to use `willMoveToWindow/didMoveToWindow`
pair. `CommonUIView/CommonUIViewController` provides `installSubcomponents/
deinstallSubcomponents` methods for your convenience.

A model must be assigned **before UI session starts**, and must be deassigned
**after UI session ends**. Model lifecycle is independent from UI lifecycles,
but it can be driven by UI events, so **UI code must manage models carefully 
to alive while live session of thier corresponding UI parts**.

Points:

-	Model code does not care UI code. It lives alone.
-	But their movements are controller by external calls.
-	UI consumes model only while thier live sessions.
-	UI manages models to be alive while live sessions of thier 
	corresponding UI.
-	Lifetime of a components are controller by its container.
-	A component cannot kill itself in single synchronous step.
-	To do that, the kill must be deferred by one step.
	In other words, asynchronously. But this is practically
	prohibited because anything can happen in that one step.
-	A component can be killed only by alien signal.
	Such as user-input or delayed (asynchronous) command.

In other words, UI (session) lives shorter than models.

	