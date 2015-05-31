README
======





Provides cancellable and blocking interfaces to asynchronous I/O 
features.
This sacrifice some memory to obtain easier programming model.

-	Non-blocking I/O is fine but harder to program without any benefit.
	Each fragment of I/O call is fragmented into multiple places of the
	program, and then execution sequence is really invisible, and 
	maintaining it is annoying.

-	Blocking I/O is easier to do whatever, but normally does not 
	support cancellation, and that's a critical issue on end-user GUI 
	applications.

-	We don't need scaling on most end-user GUI app. If needed, it must
	be handled as a part of optimisation, rather than a regular 
	structure. Though non-blocking consumes relatively less memory and
	that's desirable feature, but in most cases, I/O operations are 
	serialised on client side, and we don't need many of I/O thread to
	perform blocking operations, so memory consumption is not a big
	issue when compared to the benefits of maintenance easiness. 

-	There're bunch of open-source libraries to provide simple and 
	convenient I/O routines, but all trapped in a kind of fragmented
	executions.

-	Even with such trials, there's no purely functional way to do I/O.
	Due to impure and unpredictable nature of alien world. Most 
	libraries which are claiming FRP are not really functional.

-	Fortunately, GCD provides nice semaphores. We can build a blocking 
	interface on top of this.




Benefits
--------
When compared to typical blocking/synchronous I/O in Cocoa, this 
provides these benefits.

-	Progress monitoring in blocking manner.
-	Cancellation.

This is especially good for network I/O which spends more time 
on communication latency rather than actual transferring. Network I/O
can take very long time regardless of amount of data, and cancellation
is usually required.





Overall Architecture
--------------------
Core implementation concept is GCD semaphores. We can block a operation 
with GCD semaphores. Then, just start asynchronous I/O, and wait until
the operations finishes using semaphores, and return when it's done.












FRP?
----
Cancellable I/O cannot be done in purely functional manner, and then it
is impossible to implement this in FRP. Most libraries which are claiming
FRP are not really functional.



















