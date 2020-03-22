#
# Badge Firmware
#
# Requires Microchip XC8 MPASM assembler and MPLABX installed (just for PicKit3 usage)
#
# Assemble and link the program to a HEX file:
#	make
#
# Program a chip using PicKit3
#	make flash
#

PROJECT := badge

# Folder configurations
SRCDIR := src
BUILDDIR := obj
TARGETDIR := bin

# Processor type
MP_PROCESSOR_OPTION=10lf322


# define the location XC8 was installed
# and then use that to define the various tools we need
XC8_LOCATION=/opt/microchip/xc8/v2.10
MPLABX_LOCATION=/opt/microchip/mplabx/v5.30

MP_AS=$(XC8_LOCATION)/mpasmx/mpasmx
MP_LD=$(XC8_LOCATION)/mpasmx/mplink
MP_HEX=$(XC8_LOCATION)/mpasmx/mp2hex
MP_PROG=$(MPLABX_LOCATION)/mplab_platform/bin/mdb.sh

# Find the sources, dependencies and compute the object files

DEPENDENCIES := $(SRCDIR)/morsecode.inc		# Applies to all asm files because.. lazy and dependency detection is hard in MPMASM

SRCEXT := asm
SOURCES := $(shell find $(SRCDIR) -type f -name \*.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

TARGET := $(TARGETDIR)/$(PROJECT).hex

# Flash programming. We use the mdb.sh command shipped with MPLABX, while painful
# it seems to be the only support for the PicKit3 currently.
PROG_CMDS := $(BUILDDIR)/programming.cmds
PROG_DEVICE := PicKit3 -p

# Main target the hex file. this is the default target
$(TARGET): $(OBJECTS) Makefile
	@mkdir --parents $(dir $@)
	@echo "[LNK] $(@:.hex=.coff)"
	@$(MP_LD) -p$(MP_PROCESSOR_OPTION) -w -x -m"$@.map" $(MP_LINKER_DEBUG_OPTION) -o"$(@:.hex=.coff)" $(OBJECTS)
	@echo "[HEX] $@"
	@$(MP_HEX) $(@:.hex=.coff)


# Assembly rule, Note that we assume that all ASM files are dependent on all the includes..
$(BUILDDIR)/%.o: $(SRCDIR)/%.$(SRCEXT) Makefile $(DEPENDENCIES)
	@mkdir --parents $(dir $@)
	@echo "[ASM] $<"
	@$(MP_AS) -m -p$(MP_PROCESSOR_OPTION)  -l"$(@:.o=.lst)" -e"$(@:.o=.err)" $(ASM_OPTIONS) -o"$@" "$<"

# automatically generate the programming commands for mdb.sh
# this takes the target file and other configuration from the Makefile and generates
# the programming script for the mdb.sh program
$(PROG_CMDS): Makefile
	@echo "Building flash programming command file $@"
	@$(file > $@,device PIC$(MP_PROCESSOR_OPTION))
	@$(file >> $@,hwtool $(PROG_DEVICE))
	@$(file >> $@,program "$(TARGET)")
	@$(file >> $@,quit)

# Program the chip
flash: $(TARGET) $(PROG_CMDS) Makefile
	@echo "Programming $(TARGET) ..."
	@$(MP_PROG) $(PROG_CMDS)

# clean up target
clean:
	@echo "Cleaning $(PROJECT)..."
	@$(RM) -r $(BUILDDIR) $(TARGETDIR)

.PHONY:	clean flash

.DEFAULT_GOAL := $(TARGET)


