















Architecture & Naming Convention
--------------------------------
A UI component is built with a controller and its view or view-controllers.

A UI component and is built with two parts. One is controller and
the other is view. For example,

- FileTreeController
- FileTreeView



Every UI is basically implemented in view, and named like `~View`.


All views are named like `~View`. Viewd named like `~View` are all pure views,
and does not interact with model. 
Model interactions are all done in a view-controller. These view-controllers
are in charge of interacting with model. 

-	ViewController1
	-	ViewController2
		-	View4
			-	View5
			-	View6
	-	ViewController3
			-	View7









Lifecycling
-----------
Model exists independently from UI. Then it will never be affected by UI.
When you write model code, do not consider UI lifecycling.

UI depends on model. Each UI component that consumes model always have 
`weak var model: T` property, and model will be assigned at here. 

All UI components should have explicit concept of session start/end. For
`NSView` classes, it's recommended to use `willMoveToWindow/didMoveToWindow`
pair. `CommonView/CommonViewController` provides `installSubcomponents/
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

	
















Issue History
-------------

-	`NSOpen/SavePanel` often trigger QuickLook C++ exception.
	This is due to lack of App Sandbox configuration. Turning 
	on sandboxing and give some read-write access to user-
	selected files. Then this will disappear. 

	But! Enabling Sandboxing disables shell command execution
	that is currently very essential for current version of 
	this application at least for a while.

	So, I cannot enable sandboxing. And temporarily, I decided
	just to disable C++ exceptions. This with this, I cannot
	track LLDB exceptions...







