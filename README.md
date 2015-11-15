







![](Preview.png)








Design Decisions --- File Tree
------------------------------
File tree navigaton NEVER steal user focus. (Xcode does this and it's annoying)





To Do
-----
- Implement file tree display correctly.
- Add file tree context menu operations: new file, new folder, reveal in Finder, ...
- Add dumb text editor.
- Handle selecting file in file tree and show it in text editor.
















Architecture & Naming Convention
--------------------------------
Driver runs shell and model. And does nothing else.
Shell manages GUI. It places GUI components and manages layout and transition.
Model keeps all data and selection* states. It limits mutation, and provides
shared storage for states that used by multiple GUI components.
Each GUI components are fully segregated, and don't talk each other for data.
Each GUI components can be out-synced, and no guaratee of synchronization is
provided.
Nested GUI components are all same. But container GUI component need to set 
contextual model and capsulated container GUI component.

* If you're not sure what's selection state that need to be stored in model,
  check whether it should be shared among multiple view components.


- "Event" means an event happened to an object. 
- "Notification" is a composition of "sender" and "event".
- For `UIState`, notification sender works as an identifier to identify where 
  the state belongs to.













A UI component is built with a controller and its view or view-controllers.

A UI component and is built with two parts. One is controller and
the other is view. For example,

- FileTreeController
- FileTreeView



Every UI is basically implemented in view, and named like `~View`.


All views are named like `~View`. Views named like `~View` are all pure views,
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





- Views don't talk to each other for data.
  
  Multicasting event has a serious issue. That is undefined order between observers.
  So, if your views talk to each other for some data retrieved from model, it's very likely
  to be unsynced. Some view always take data earlier than another view, and this makes
  unpredictable bugs. Just don't make views to talk to each other, and synchronize all
  data via model.



















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
	just to disable C++ exceptions. Though I cannot track LLDB
	exceptions with this...







