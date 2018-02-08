# redzone
for those paranoid that the kernel clobbers userspace

#### why though

The System V ABI guarantees that the 128 bytes below the stack pointer
will always be preserved by the operating system.
This 128-byte area is known as the "red zone".
Unfortunately, the ABI does not explicitly say what happens to memory **beyond**
the red zone.
In particular, interrupt service routines (ISRs) *may* dump process state onto the userspace
stack just beyond the red zone, before switching to a different stack to handle
the interrupt (e.g, preemption by the kernel).

My understanding is that some older kernels, like Linux 2.6.x, would
write beyond the red zone.

#### goal

Test the theory that your favorite operating system does *not* dump anything beyond
the red zone, I've written this little tool.

#### how to use

1. run `make`
2. run `./redzone`
3. after about 20-30 seconds, you will see the result message.


If you see a happy message, the kernel did not write a non-zero value to the
red zone or any part of at least 1-2kb beyond the red zone.
Otherwise, we detected a discrepancy.
