import subprocess
string = '0xf7db2000'

for i in range(1000):
  result = subprocess.check_output('ldd ./secure_shell | grep -i libc', shell=True)
  if string in result.decode('utf-8'):
     print(f"matched! {string}")
