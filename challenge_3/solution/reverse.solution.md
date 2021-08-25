Following on from the override solution, we'll look at gaining a reverse shell

### Checking ASLR

To identify if ASLR (Address Space Layout Randomization) is present, we can
see the memory location that libc is placed at changes for each run:

```
user@490ddfc1d226:~/app$ ldd ./secure_shell
        linux-gate.so.1 (0xf7f3c000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xf7d3d000) <----
        /lib/ld-linux.so.2 (0xf7f3d000)
user@490ddfc1d226:~/app$ ldd ./secure_shell
        linux-gate.so.1 (0xf7fb0000)
        libc.so.6 => /lib/i386-linux-gnu/libc.so.6 (0xf7db1000) <----
        /lib/ld-linux.so.2 (0xf7fb1000)

```

As the memory location different, ASLR is enabled.

### Disable ASLR
