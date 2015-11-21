





(Under development...)


![](Preview.png)






To Do
-----
- Cargo output parsing and display. (via Unix pipe)
- Racer output parsing and display. (via Unix pipe)
- Racer autocompletion GUI support.
- Pretty display of stacks and variables in debugging UI.
- Drag & drop support in project file tree pane.

Done
----
- Fix to make cargo to work without `cc` error. (it was a configuration problem that was caused by Homebrew)
- Rework on shell / cargo handling. (now sometimes it emits output after remote task finished)
- Adding/deleting files in workspace.
- Opening an existing workspace.
- Creating a new workspace.
- Project file list saving.
- LLDB integration.
- Project file list format design.


There're many more, but I'll think about them later after I finish these jobs.







Requirements
------------
- Rust platform 1.4.0 installed with Cargo and callable from shell.
- Latest Racer installed and called from shell.












