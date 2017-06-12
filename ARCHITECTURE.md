ARCHITECTURE
============
Hoon H.
2017/01/14


- App
  - Services
  - Features
  - Shell

Communications between each layers are done soley by passing messages.





"No"s & Why
-----------
There's no "app-level" or "feature-level" controller which controls shell.
To control shell, the controller MUST be able to control every details of
the shell. Which means hard coupling. And without hard-coupling, it's impossible
to control shell completely. So, shell MUST be controlled by itself. That's why
shell knows everything about features, but features know nothing about shell.

But!, this doesn't mean the features are a sort of "pure data". There's no such
"pure data". As long as an app is a UI program, UI is the essential part, and
features are just a supporting structure for the UI. DO NOT try to design any
sort of "pure data" in features. Design of features are bound to design of UI,
and a way coupled to how shell works. Features is more like to be a 
"data sharing" layer of a shell rather than a central pure data storage. And
there's no such central pure data storage. Such storage elevates coupling level
between components, so avoided as much as possible.












DEPRECATED DESIGNS (ARCHIVED UNTIL NEW DESIGN SETTLES UP)
---------------------------------------------------------

Program at large;
- Controllers manage communication between processes and interfaces.
- Processes performs detail control over time. (Receive and send signals from/to controllers over time.)
- Interfaces performs detail control over space. (Receive and send state from/to controller for the moment.)

Processes at small;
- Processes access feature services to perform operations.
- Processes makes and manages multiple execution contexts.
- Processes are now implemented using `EonilPco`, but can be changed if needed.

Interfaces at small;
- Interfaces serves dual duties of input and output. (This is because `AppKit` is designed to be like that.)
- Interfaces are now implemented using `AppKit`, but can be changed if needed.
- Input of interfaces scan user control to controllers as is naively but in simplest form.
- Output of interfaces render state from controller to users as is naively but in simplest form.



