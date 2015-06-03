README
======
2015/01/19
Hoon H.






Lessons
-------

First trial. Builing LLDB myself, and communicate with it via public C++ API.

-	Self building of LLDB takes too long time and too much spaces. (100MiB)
-	It's not effectively shippable and manageable within Git repository.
-	It slows down iteration speed.
-	It requires code-signing, and it's annoying without OS X developer license.
-	I am not sure how well this would work. OS X platform may have some hidden 
	limitation that are not useable from non-Apple version LLDB.
-	Anyway, this is still the ideal way to use LLDB.

Second trial. Using LLDB included in Xcode via public C++ API.

-	Apple uses thier own internal version of LLDB.
-	It seems binary incompatible with open-sourced version of it.
-	Open-sourced version of public headers don't work for Xcode version.
-	Xcode version reports 320.x version, but Apple's open-sourced only 310.x versions.
-	No way to use this.

Thord trial. Using LLDB via Python API.

-	Spawning and running remote Python process is OK.
-	I am not very familiar with Python. It's hard.
-	I need to design and implement whole new "protocol" to manage session.
-	Writing controller for remote Python process is just same as building a remote debugging protocol.
-	Then why wouldn't I use just exsting, proven and well-supported one --- GDB RSP.

Fourth trial. Controlling LLDB via GDB Remote Serial Protocol.

-	Basic idea is spawnining remote debugger process and make it to work as server mode.
-	Now work in progress. Update as progressed.
-	GDB RSP lacks many features, and does not seem to be enhanced further.
-	Finall abandoned.

After more more than 3 weeks, I finally decided to go back to second approach.
Low-enough version of header can provide some minimal feature set. Anyway this
is just a quick starting point, and it will evole into first option eventually.

See `Eonil/LLDBWrapper` for details.







