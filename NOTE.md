
What to Remeber
---------------
- There's NO GLOBAL CONSISTENCY. Keep it work without it.
- If your app require global state consistency, it cannot
be split to scale up.
- So, design your app state to be reliable without such
global consistency.
- Avoid local ID. Use GLOBAL IDs whenever possible. 
It helps to build loosely-coupled system.
- Event and action are different. 
- Event is "Some STATE has been changed". It's about state.
- Action is "User DID something". So it's not about state.
- But handling is same.
- Dispatch event only if the state is CONSISTENT.
- DO NOT process a new message while you're dispatching message.
It produces infinite loop.
- Do not split store for two hardly-coupled states.
Communication becomes too complex.
- View MUST be able to render ANY input regardless of it's 
broken or not.  
- DO NOT make cyclic event dispatch between components.
- Do not PROCESS events/actions immediately.
- You CANNOT avoid cycle by making event dispatch async.
It just promotes the sync cycle to async cycle, and doesn't
eliminate them. 
- Sync cycle yields a stack overflow, and easier to debug.
Keep it sync.
- Install a global re-entering check in event/action channel.
And FIX the cycle BUG in your code.
- Write code that can be captured by LLDB async stack capturer.

- One of message dispatch and message processing must be async to
avoid potential infinte loop.
- Do not process a new message while

- NO WAY to avoid async message dispatch. It produces clean 
architecture, but it makes debugging harder. Find a way to
debug easier with async situation.






















