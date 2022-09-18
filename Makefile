BINDIR = bin
VPATH = src
BINS = $(addprefix $(BINDIR)/, hello-world.bin )
ASM = asm6809.exe --dragondos

$(BINDIR)/%.bin : %.asm
	$(ASM) --output $@ $<

all: $(BINS)

hello-world.bin: hello-world.asm dragon.asm
