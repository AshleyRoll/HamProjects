#
# Badge Firmware
#
# Requires Microchip XC8 MPASM assembler
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

MP_AS=${XC8_LOCATION}/mpasmx/mpasmx
MP_LD=${XC8_LOCATION}/mpasmx/mplink
MP_HEX=${XC8_LOCATION}/mpasmx/mp2hex


# Find the sources, dependencies and compute the object files

DEPENDENCIES := $(SRCDIR)/morsecode.inc		# Applies to all asm files because.. lazy and dependency detection is hard in MPMASM

SRCEXT := asm
SOURCES := $(shell find $(SRCDIR) -type f -name \*.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.o))

TARGET := $(TARGETDIR)/$(PROJECT).hex


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
	@${MP_AS} -m -p$(MP_PROCESSOR_OPTION)  -l"$(@:.o=.lst)" -e"$(@:.o=.err)" $(ASM_OPTIONS) -o"$@" "$<"


clean:
	@echo "Cleaning $(PROJECT)..."
	@$(RM) -r $(BUILDDIR) $(TARGETDIR)

.PHONY:	clean dump

.DEFAULT_GOAL := $(TARGET)


