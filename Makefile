BINDIR = bin
VPATH = src
BINS = $(addprefix $(BINDIR)/, hello-world.bin characterset.bin )
ASM = asm6809 --dragondos

$(BINDIR)/%.bin : %.asm
	$(ASM) --output $@ $<

all: $(BINS)

hello-world.bin: hello-world.asm dragon.asm
characterset.bin: characterset.asm dragon.asm
