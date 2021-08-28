# $@ = target file
# $< = first dependency
# $^ = all dependencies

CC := gcc
CFLAGS := \
	-fno-stack-protector \
	-Wl,-z,norelro \
	-g \
	-no-pie \
	-m32

secure_shell: secure_shell.c
	${CC} ${CFLAGS} -o $@  $^

clean:
	rm secure_shell
