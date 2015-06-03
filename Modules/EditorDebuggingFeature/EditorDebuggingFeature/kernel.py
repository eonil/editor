
#	LLDB remote execution kernel.
#	Intentionally crashes for any errors.

import sys
import lldb

while True:
	exec(sys.stdin.readline())
	sys.stdout.flush()