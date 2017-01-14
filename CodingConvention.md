


- Views: 
    Render current state, wait & receive user input.

- Processes: 
    Describe & execute sequential (order-dependent) programs.
    Communicates using channels.

- Controllers: 
    Receive user input from views. Perform state mutation.
    Connects views and processes.










Controllers
-----------
Controllers usually employ multiple concurrent processes.
A "process" is always a terminal control flow which finishes
with no return value. Guaranteed lack of return values makes
processes are ideal to get triggered by a command ID.
A process executes its main entry function. This function 
can return a value, and call subroutine.
If you need to call another process as a subroutine, just 
call its main entry function, and DO NOT try to execute it
by sending command ID.

Controllers keep view states and pass them to views by copy.
View just renders them.

Views
-----
Views are always a (mostly-)stateless renderer.
Views accept commands (method call) and update themselves
to follow the command. Keep view commands can be idempotent
as much as possible. Non-idempotent commands are allowed,
but only when absoluted required, and must be used very 
carefully. 
For guidance, make command ID and make single mutator 
method to process the command. Keep all commands defined by
ID idempotent. If you need some non-idempotent command,
it'd be better to define them as a direct method call.
User actions creates an event, and will be delievered to
delegate function cascadely. The event will finally be
delivered to controllers, and controller will route them
to proper processes (signaling) or services.











Processes
---------
A process means a long running execution over time. Processes involves
multiple steppings(pause and resume) over time.

- A process MUST have a segregated memory, and should communicate only 
  by sending message. 
- The message MUST be an immutable value object.

There're many types of processes.

- **State machine**. This is most basic form of state. Theoretically, 
  a state machine can represent any kind of computational process, but
  writing and debugging state machine is very hard so writing state
  machine is usually undesired. Anyway, if you have no idea of what's
  the best, just choose state machine. Because state machine can cover
  any computation, so you won't have subtle limitation issue like in 
  case of another form of processes. 
  Though state machines can represent everything, repreesnting 
  branching and loop is miserable experience. I strongly recommend to 
  use another abstractions to write such processes.

- **Thread**. Thread is an easy way to write a state machine in 
  structured language. The problem of thread is that they implicitly 
  allows parallel execution, so you always be prepared for it. I mean, 
  data-race and synchronization. Also, thread is very expensive in both
  of space and time. Because is needs kernel level orchestration.
  (in this article, *thread* means plain unix thread)

- **Flow**. This simply means something like "Bolts". Good for coding
  serial && straightforward process with simple branching, but no good
  for loop because you need to represent all loops by recursion.

- **Rx**. This is "Bolts" on steroid. I am not sure what kind of things
  are possible with Rx yet. Anyway AFAIK, Rx is able to code loops
  easier than Bolts.

In both of Flow and Rx, it's impossible to make an async subroutine.
So they can define only straightforward processes. So, free composition
of program pieces are not possible.

- **Coroutine**. There are some coroutine libraries which provides
  multiple execution contexts (stacks) in Swift. Anyway, these are
  fundamentally a hack, and no one can guarantee proper execution.

- **DSL**. Providing a embedded language which support multiple execution
  context natively to overcome limits of host language.

Ideal solution is native support of multiple execution context by 
compiler. Anyway this requires multiple execution stack management,
and most compilers do not support it.

Policty
-------
- Use thread primarily. This is native form of multiple execution context.
  Do not share any state betweehn threads. Always synchronize. Performance
  will be dropped, but this is about flow-control, not performance.
  Synchronize by communication. Do not use GCD to spawn a new thread.
  Keep number of thread as small as possible.

- Consider state machine secondarily.






















