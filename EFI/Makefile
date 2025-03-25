ARCH            = $(shell uname -m | sed s,i[3456789]86,ia32,)
OBJS            = bootmgfw.efi.o
TARGET          = bootmgfw.efi

EFIINC          = /usr/include/efi
EFI_CRT_OBJS    = $(EFIINC)/crt0-efi-$(ARCH).o
EFI_LDS         = $(EFIINC)/elf_$(ARCH)_efi.lds

CFLAGS          = $(EFI_CRT_OBJS) -fno-stack-protector -fpic \
                  -fshort-wchar -mno-red-zone -Wall \
                  -I$(EFIINC) -I$(EFIINC)/$(ARCH) -I$(EFIINC)/protocol \
                  -DEFI_FUNCTION_WRAPPER

LDFLAGS         = -T $(EFI_LDS) -shared -Bsymbolic -L$(EFIINC) $(EFI_CRT_OBJS)

all: $(TARGET)

%.efi: %.so
	objcopy -j .text -j .sdata -j .data -j .dynamic \
		-j .dynsym -j .rel -j .rela -j .reloc \
		--target=efi-app-$(ARCH) $^ $@

%.so: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@ -lefi -lgnuefi

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(TARGET) *.so *.o 