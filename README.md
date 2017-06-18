Editor6
=======
Hoon H.



Architecture
------------

- This is a multi-document app.
- This treats each document as a separated app. (or process) 
  A document cannot acces other document directly.
  Communicate only by copiable message.
- Driver is also a separated app.
  It cannot access or be accessed by any document.
- So there's no centralized concept of "app". 
  Driver is a bootstrapper and overall manager, 
  but it doesn't do many jobs. It's literally just
  a driver, and most works are done by documents
  themselves.
- Driver and each documents are configured to be an
  independent app. Which means they have thier own
  set of services, features and shells.

Each app divided into four tiers.

- Services (unorganized individual functionalities, can perform external I/O)
- Features (defines each feature of the app, also communicate to each other)
- Shell (provides human interface)
- App (holds and manage inter-tier operations)

Some app can lack some tiers if they don't need it or
small enough.

Driver is not a singleton. You can make many drivers.
But anyway, due to architecture of AppKit which forces
to have only one document-controller, all drivers share
and see same set of documents. So making many driver is
effectively meaningless.































Architecture
------------
This app is built with 3 major pieces.

- Views.
- Controllers.
- Services. (models)

Views are responsible to render UI and accepting user input.
User input will be dispatched back to controllers.

Controllers takes user input and generates UI states. UI states
will be delivered to views to render UI.

Controllers may execute some operation and query some information
from services by user input.

Services are globally available components which provides access
to various independent features. Services are actually gateway
interfaces to alien features. This plays rols of "models" in
traditional MVC architecture.

*Services* are named differently, becuase I think this is a bit 
different with traditional models. 

- Services are one level lower than controllers, and available
  on all controllers.
- Services are collection of objects which provides data access.
  This is not a collection of data-types.





Available Services
------------------
These are list of available services and its internal dependencies.

- Project service
  - File system

- Build Service
  - Cargo

- Debug Service
  - LLDB

- Code completion Service
  - Rust Langauge Server













Directory Layout
----------------
I will use this layout until SwiftPM to be fully supported by Xcode.
No further plan has been made.

    /                   Root
    /modules            Xcode projects stored in this repo.
    /submodules         Xcode projects linked by Git submodule.
    /packages           Swift Packages.

All Swift Packages are packed in `Editor6DepPack`.
This package is just an aggregation package which collects every dependencies.


System Diagram
--------------
There are a few of big actors. (in other words, microservices)
    
- Driver (one)
- MainMenuManager (one)
- WorkspaceDocument (many)

ApplicationDriver manages loop that processes in/out messages.

`Driver` operates overall program. `MainMenuManager` and
`WorkspaceDocument`s send events (including state changes) to
`Driver`. The driver merges those informations
into its own local state to derive a new state and effects.
Newrly derived states and effect are propagated back to 
`MainMenuManager` and `WorkspaceDocument`s.

Driver manages only centrally shared stuffs. For instance, main-main.
Each workspace owns and manages their own states.

Driver needs workspace states to display main menu properly. For this, 
driver requires all workspace to dispatch back their states back to driver.
Anyway, workspaces does not accept state snapshot from driver.

Main menu dispatches received actions to driver. Driver routes actions to
operation with current state snapshot. Operation executes long running 
interactive flow. For each steps in operation, operation flow can send
some commands to any components. For instance, it can send file-add command
to workspace.



Workspace Subsystem
-------------------
Each workspace document actually serves as a subdriver for workspace subsystem.
So from now on, we call it *workspace-driver*.
There are three components.

- WorkspaceDriver 
- WorkspaceModel
- WorkspaceUI

Model, UI and driver correspond to M/V/C in MVC architecture.

Workspace model keeps workspace state and performs any operation including external I/O.
Workspace UI just renders workspace model, and receives user input.
Workspace driver simply connects model and UI. Model provides a control methods, and UI
can call them directly. Such control methods produces multiple functions to execute. 
Workspace driver receives such functions and execute them. While processing such programs
model MAY produce state change functions. Driver also monitor them and pass them to UI.
This is usually enough to make UI to render themselves.

    Model -> Driver -> UI
    UI -> Model (control methods)
    
*ALL* of model control methods will be passed to driver, and everything will be executed
in driver by driver. Driver actually serves as trampoline.
    




Architecture
------------
Follows looping data-flow architecture.
In other words, FRP.
In other words, message-pump.
In other words, Redux. Elm.
Whatever.

    Driver
    - MainMenuManager
    - WorkspaceDocument...

MainMenuManager and WorkspaceDocument acts like independent servers.
They *own* thier own states, and updates them themselves. WorkspaceDocument
dispatches any changes back to Driver. Driver owns its state, and propagates
it to main menu.



View shares states that are only required to be known to other components.






























