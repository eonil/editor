








Model is designed to work soley in memory. It does not perform
any external I/O by itself. All external I/O is done by
pluggable several interfaces, and you need to provide actual
implementations for it. This is an intentional design to allow
mock-test.

There's an exception -- LLDB. I didn't want to wrap them up all,
so I just exposed them, and that can involve some external I/O.
Anyway, that's an exceptional case, and all external I/O must
be done through an abstraction layer in anything else.