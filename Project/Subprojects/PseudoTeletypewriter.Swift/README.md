Eonil/PseudoTeletypewriter.Swift
================================
Hoon H.


Simple `pty` on Swift.

Here's quick example.

````Swift

	let	pty	=	PseudoTeletypewriter(path: "/bin/ls", arguments: ["/bin/ls", "-Gbla"], environment: ["TERM=ansi"])!
	println(pty.masterFileHandle.readDataToEndOfFile().toString())
	pty.waitUntilChildProcessFinishes()

````

This gives me this output.

	total 0
	drwxr-xr-x  6 Eonil  staff  204 Jan 12 22:05 [34m.[39;49m[0m
	drwxr-xr-x@ 3 Eonil  staff  102 Jan 12 22:00 [34m..[39;49m[0m
	drwxr-xr-x  7 Eonil  staff  238 Jan 12 22:03 [34mBSD.framework[39;49m[0m
	drwxr-xr-x  7 Eonil  staff  238 Jan 12 22:04 [34mPseudoTeletypewriter.framework[39;49m[0m
	drwxr-xr-x  3 Eonil  staff  102 Jan 12 22:05 [34mTest2.app[39;49m[0m
	drwxr-xr-x  4 Eonil  staff  136 Jan 12 22:05 [34mTest2.swiftmodule[39;49m[0m

You can check the ANSI escape color code. It is working as interactive pseudo terminal.

`sudo` also works. Though I haven't tested yet, but I believe `ssh` also should work.





License
-------
This project is licensed under MIT license.