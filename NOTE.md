


Naming Conventions
------------------

- `...Controller` is a state maintainer. It has some internal state
  and manages it by providing limited mutator methods.

- `...Service` is a gateway to lower level features that are 
  available to all higher level components.
  A service is just a gateway interface. It usuallt backed by one or
  more controllers.











































Basic flow.

    Driver accepts an action.
    Driver sends it to model.
    Model translates action into state transaction.
    Model applied the transaction on its state.
    Model returns the transaction and new state.
    Driver sends it to view controller.
    View controller translates them into view commands.
    View controller manipulates view to make a new look.

View-side long running flow.


Views can initiate some long running interactions.

Long running background flow.

    Driver accepts an action.
    If the action need to involve long running flow, 
    Driver translates it into operation message.
    And sends them to service.
    Service initiates long running flow.
    Long running flow can send another messages to 
    Driver.
    The long running flows are just another actors.
    They can send messages to driver.


    


Driver initiates model and view.
Driver receives messages. Driver queue and collect them
and sends them to model.

Model accepts the messages, 


Driver is just a message loop. It accepts and queues messages 
from other parts of the app, and processes them at once.

Driver can take messages from any other parts of the app. 
- Model
- View
Model sends event messages. An event message may contain model
state snapshot if needed.
View sends action messages. An action message may contain view
state snapshot if needed.

For whatever messages, driver chooses where to send the message
to. 


Driver accepts model and view action messages, queue and process 
them at once.

- View controllers are responsible to translate model state into
  view state.

























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






















