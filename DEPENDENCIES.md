DEPENDENCIES
============







-	Racer

	-	Ship within the app as compiled binary.
	-	Run as separated external process.

-	LLDB

	-	Use system LLDB via public API.
	-	Link to Xcode's one using system path at runtime.
	-	That means this requires a proper Xcode installation.











Management
----------
This project has many dependencies and they're managed by two
different methods.

-	Linked Git submodule. (`/Submodules` folder)
-	Local copied subprojects. (`/Subprojects` folder)

Preferred way is Git submodule, but it needs extra management cost.
Use this for stable components.


Use local copying if the component is yet unstable, and developed
togather with this project. For example, `Editor~` components are
all dedicated components only for this project, so there's no reason
to separate them into a new repository.

Sometimes I local copy some obviously separated components. (such as
`LLDBWrapper`) This is just to accelerate development speed of unstable
components by reducing management cost(managing Git submodule isn't
that simple), and will be moved to linked submoule as it become stable.

But recently, I am discoverying this local copying strategy is actually
feeling better than any Git submodule, and it is still unclear which
method to use in future. It's also possible to local copy everything.
That means ready-made source repository, and we don't need to worry
about validity of submodule links anymore.


