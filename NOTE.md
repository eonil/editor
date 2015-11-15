




Design Decisions -- File Tree
------------------------------
File tree navigator NEVER steal user focus for any items. (Xcode does this and it's annoying)









Architecture & Naming Convention
--------------------------------
Driver runs shell and model. And does nothing else.
Shell manages GUI. It places GUI components and manages layout and transition.
Model keeps all data states. It limits mutation, and provides shared storage for states that 
used by multiple GUI components.
Each GUI components are fully segregated, and don't talk each other for data. Each GUI 
components can be out-synced, and no guaratee of synchronization is provided.
Nested GUI components are all same. But container GUI component need to set 
contextual model and capsulated container GUI component.

Many GUI components need shared state that are belong only to GUI stuffs. That are not 
appropriate to be placed in model part. I call this UI-state, and they are attached to related
model node using global table. (See `UIState` type) Usually selection informations are stored
here.

This follows classical MVC model. That means, user input will be delivered to controller and
controller mutates model (and UI-state) and view displays them. 

We DO NOT track all each mutation of all each model state. Because it's overly complex and gives
almost no benefit. For example, workspace file tree does not provide precise tracking event on 
all each ndoes. Instead, it just broadcast tree-did-change event. File tree UI just redraws
everything that are changed.

Events are delivered using global notification facility. We DO NOT provide per-node event 
multicaster because tracking deep object graph (or tree) is really painful where it gives 
almost no benefit. For example, tracking of deep file node tree is very painful, hard and 
complex. It brings more bugs to fix, and consumes more time to work. I don't have such 
resources. Instead, each event will be broadcasted as global notification, and interested 
parties need to observe them. Because there's no pre-filtering of sender or receiver, each 
event can cost up to O(n^2), but it's SIMPLE to maintain. Period.

- "Event" means an event happened to an object. 
- "Notification" is a composition of "sender" and "event".
- For `UIState`, notification sender works as an identifier to identify where 
the state belongs to.

A GUI component will be implemented with binding to model fully in a view, not a view-controller. 
That's because view-controller seems in charge of transition rather then model binding. Don't
be confused by its name "controller".


























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
- `NSOpen/SavePanel` often trigger QuickLook C++ exception.
  This is due to lack of App Sandbox configuration. Turning 
  on sandboxing and give some read-write access to user-
  selected files. Then this will disappear. 

  But! Enabling Sandboxing disables shell command execution
  that is currently very essential for current version of 
  this application at least for a while.

  So, I cannot enable sandboxing. And temporarily, I decided
  just to disable C++ exceptions. Though I cannot track LLDB
  exceptions with this...





- Architecture has been replaced completely 3 times. History 
  of them are all fully stored in these branches.

  - `trial1`
  - `trial2`
  - `trial3`

  `trial1` is most feature-complete version with oldest legacy
  architecture. It worked well, but I could not expand it more
  because the architecture placed too much responsibility on 
  higher level controllers. 

  `trial2` and `trial3` was trials to use multicasting storages.
  It's horribly failed. Major drawback was deep object tree. 
  Tracking and observer registration state management of deep
  model object tree was incredibly hard, and I usually ended up
  with fighting with deep recursive node trackings bugs. If I 
  had enough time, it wouldn't be so bad, but time is most 
  precious resource for me, and I had to abandon this 
  architecture.

  Though separating all each state into multicastable node can
  provide precise tracking and potentially better performance,
  but both of them are not very desired for current version of
  app. (maybe forever?)

  One more lesson learned was GUI component segregation. 
  "Multicasting" means it's impossible to control order of 
  executions between observers, then observers cannot assume a
  specific state when they receive an event. Other component
  can be in unexpected state. The conclusion is, just segregating
  them completely. GUI components (views, output, or whatever)
  should depend soley on model data, and should not interact 
  to each other. The only allowed interaction should be assigning
  model object, or pure view operation.




























