MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-gcc

CFLAGS = -mcmodel=medany -march=rv32imac -mabi=ilp32 \
	     -Wextra -ffunction-sections -fdata-sections -Os
LDFLAGS = -L$(MAKEFILE_DIR)../riscv-probe/build/lib/rv32imac -lfemto \
		  -Wl,--gc-sections -Wl,--nmagic -nostartfiles -nostdlib -nostdinc -static

objs  = $(patsubst %S,%o,$(filter %.S,$(srcs)))
objs += $(patsubst %c,%o,$(filter %.c,$(srcs)))

.PHONY: all
all: $(objs) $(target)

$(target): $(objs)
	$(CC) $(LDFLAGS) $^ -lfemto -o $@

%.o : %.S
	$(CC) $(CFLAGS) -c -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	$(RM) $(objs) $(target)
