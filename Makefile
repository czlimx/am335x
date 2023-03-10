##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [3.15.2] date: [Fri Feb 24 23:44:06 CST 2023]
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

######################################
# target
######################################
TARGET = myboot


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -O0 -g


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
arch/arm_faults.c \
driver/interrupt.c \
app/main.c

# ASM sources
ASM_SOURCES =  \
arch/exception.s \
arch/startup.s \
arch/vector.s \
arch/arm_arch.s \
arch/arm_cache.s \
arch/arm_mmu.s

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp -DASSEMBLY
CP = $(GCC_PATH)/$(PREFIX)objcopy
DP = $(GCC_PATH)/$(PREFIX)objdump
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp -DASSEMBLY
CP = $(PREFIX)objcopy
DP = $(PREFIX)objdump
SZ = $(PREFIX)size
endif
DIS = $(DP) -D
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################

# AS includes
AS_INCLUDES = \
-Iarch/include \
-Idriver/include

# C includes
C_INCLUDES =  \
-Iarch/include \
-Idriver/include

# compile gcc flags
ASFLAGS = $(AS_INCLUDES) $(OPT) -Werror -fdata-sections -ffunction-sections

CFLAGS  = $(C_INCLUDES) $(OPT) -Werror -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = am335x.lds

# libraries
LDFLAGS = -specs=nano.specs -T$(LDSCRIPT) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections -nostartfiles -nodefaultlibs -nostdlib

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).dis $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	@$(AS) -c $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@$(SZ) $@

$(BUILD_DIR)/%.dis: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@$(DIS) $< > $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@$(BIN) $< $@	
	
$(BUILD_DIR):
	@mkdir $@		

#######################################
# clean up
#######################################
clean:
	@-rm -fR $(BUILD_DIR)/*
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***