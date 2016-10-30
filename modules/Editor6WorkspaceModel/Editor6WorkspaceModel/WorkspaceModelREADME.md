WorkspaceModel
==============
Hoon H.




Model translates user command into a serial list of functions.
Those functions will be passed to a delegate to be processed
at PRECISE timing.

So basically, every operation on model is asynchronous. There's
no synhcronous operation.

























The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
RFC 2119.












































- Synchronous command -> call the methods.
- Asynchronous command -> send command message by calling `queue` method.

Summary
-------
- Treat each model objects as data servers.
- You can read states from model objects synchronously, but only in certain
  time points.

- You cannot read from any model directly and synchronously.
  This is to prevent inconsistent state propagation. If you read at any time,
  you can read some state in between updating of dependent components, and
  it usually lead you to read inconsistent state.
  So, you must read asynchronously, and model object will feed you the state
  at consistent point. 
- You need to reconstruct state in client side by apply model notifications.












Design
------
Application basically follows **dataflow** architecture.
Which means strict oneway dataflow. 

    * Input (Controller, Driver)
    | 
    * Process (Model, State) 
    |
    * Output (View, Render)

This can be guaranteed by limiting model update in a certain
time.

This architecture works quiet well. But usually bloats code
greatly because such interactive programs usually need to 
manipulate states over time, and it's very hard to do with 
above discrete architecture. You always need to maintain some 
context ID, and pass them to state machines.

To save coding efforts, you can use coroutines. But coroutines 
are not a silver bullet. Coroutines can be executed 
asynchronously, and because it can, it usually breaks above 
oneway data-flow assumptions. Because coroutine initiated from
view can be executed in the middle of model update. And it will
break everything. Please note that Bolts or Rx are also all
a form of coroutines.

To get back such assumptions, you need to suspend coroutine 
executions when needed.

Dispatch model method manipulation code to driver, and let the 
driver to execute them so the driver can control execution 
timing. Users can access models only in a function that has
been dispatched to the driver.





Goals & Rules
---------------
- Prevent infinite loop.
- Prevent re-entering which is main source of infinite loop.
- Prevent re-entering which makes model in vague state.
- Prevent views to receive inconsistent state of model.
- Models MUST be able to provide synchronous mutator methods.
- Models MUST be able to provide asynchronous mutator methods.
- Model mutator methods can return a strongly typed value. 
  (or promise)
- Views MAY call such model methods, and continue from them.

If views can call model method, it can mutate model state.
Which means model mutation timing becomes uncontrollable.
And this is main source of inconsistent state and re-entering.
This MUST be prevented.
To prevent this, model mutator methods MUST be called only in
certain timing. And this must be done by programmers. But, 
programmers make mistakes, so we need some checking facility.
Following conditions describe how to archive it.

- Model MUST propagate notifications **synchronously** up to 
  driver.

So you can check for model update in bad timing.

The best way to get the right timing is packaging them in a 
function and dispatching them to driver and let the driver 
to call them.

If view sends an action to driver, driver will translate it 
into appropriate model method calls. In other words, action 
serves an ID for several model method call.

Model notification SHOULD describe operation rather than state.
For example, it's RECOMMENDED to use notifications like 
`addItem` or `removeItem`. Anyway, it's also RECOMMENDED to use
notifications like `reset` or `renew` to replace whole state
at once. Always use proper notifications. Because views are 
allowed to utilize this information to optimize or enhance
rendering. For example, views can use animations for newrly 
added items, but reload instantly for full resetting.

In most cases, just full resetting is enough, so most of 
notifications will be just `reset` or `renew`. In this case,
model object MAY just send the state snapshot instead of
command semantic notifications.







