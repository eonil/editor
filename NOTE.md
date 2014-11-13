NOTE
====























File System Watching
--------------------
`NSFilePresenter` simply does not work as advertised, and Apple has no
interest on fixing it. It's be abandoned at least last 4 years, and 
relying on it seems to be very dangerous. Also it has some hidden and
complex threading behavior, and it's almost impossible to deal with it.

`kqueue`/GCD based file-system notification approach does not support
notification of subdirectory, then it needs complex tracking. So it's 
been avoided.

Then the only remaining option is `FSEvents`. This is why I am using it.