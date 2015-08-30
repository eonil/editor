








Model is designed to work soley in memory. It does not perform
any external I/O by itself. All external I/O is done by
pluggable several interfaces, and you need to provide actual
implementations for it. This is an intentional design to allow
mock-test.
