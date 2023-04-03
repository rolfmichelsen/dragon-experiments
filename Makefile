BINDIR = bin
VPATH = src
BINS = $(addprefix $(BINDIR)/, hello-world.bin characterset.bin )
ASM = asm6809 --dragondos

$(BINDIR)/%.bin : %.asm dragon.asm
	$(ASM) --output $@ $<

all: $(BINS)
