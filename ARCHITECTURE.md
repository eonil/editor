ARCHITECTURE
============
Hoon H.
2017/01/14

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



