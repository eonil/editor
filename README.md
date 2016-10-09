Editor5
=======
Hoon H.

Directory Layout
----------------
I will use this layout ntil SwiftPM to be fully supported by Xcode.
No further plan has been made.

    /                   Root
    /modules            Xcode projects stored in this repo.
    /submodules         Xcode projects linked by Git submodule.
    /packages           Swift Packages.

All Swift Packages are packed in `Editor5DepPack`.
This package is just an aggregation package which collects every dependencies.


System Diagram
--------------

    Driver <-> MainMenu

    Workspace <-> Navigator
              <-> Editor
              <-> Inspector

Driver manages only central shared stuffs. For instance, main-main.
Each workspace owns and manages their own states.

Driver needs workspace states to display main menu properly. For this, 
driver requires all workspace to dispatch back their states back to driver.
Anyway, workspaces does not accept state snapshot from driver.

Main menu dispatches received actions to driver. Driver routes actions to
operation with current state snapshot. Operation executes long running 
interactive flow. For each steps in operation, operation flow can send
some commands to any components. For instance, it can send file-add command
to workspace.





