# $@ = target file
# $< = first dependency
# $^ = all dependencies

CC := gcc
CFLAGS := \
	-fno-stack-protector \
	-Wl,-z,norelro \
	-g \
	-m32 \
	-no-pie \
	-z execstack

secure_shell: secure_shell.c
	${CC} ${CFLAGS} -o $@  $^

clean:
	rm secure_shell
