

Keep Number of View-Controllers as Small as Possible
----------------------------------------------------
`ViewController`s are unit of navigation, and in this app, they are also
responsible to receive rendering heartbeat. `Shell` iterates all nested 
`ViewController`s for each time of rendering. As rendering haertbeat can
be fired up to 60 times in a second, it's pretty important to keep it 
as small as possible.

In most cases, you don't need to employ a lot of `ViewController`s. 
Instead, I recommend using `ViewController`s only for absolutely required
points. And use `View`s for any other places. 









For Maintainers
---------------
- Do not make multiple continuation from single `Task<T>`. BoltsSwift is 
    not intended for multiple branching.
- Do not `import Foundation` unless you really need it. Some classes in 
    the framework performs extenal I/O (e.g. file-system), and should be
    used only in a specific context.











Query -- Returning a Value from an Action Dispatch
--------------------------------------------------
This is **strongly** discouraged. You are requested to write logics without explicit returning value. 
Especially for user-interaction service. If you really need to return something, consider using of a kind of *cursors*.
For example, each workspace file navigator has `current` property which contains currently selected file. You make some slot
like this to store some result value. Don't care about performance because most important point of UI service is synchronized
and consistent state management and quick response, not throughput. This is unique requirement for UI service, and why 
UI service has unique structure and interface like this.









Data Flow
---------

message ->  debugging message?  -> debug service process    -> dispatch debug state to  -> UI service -> UI state -> render
            UI command?         -> UI execution service     -> dispatch action to       -> UI service -> UI state -> render
            
        






















