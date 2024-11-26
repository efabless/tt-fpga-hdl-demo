# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
SRC_DIR := $(realpath $(PWD)/../src)
PROJECT_SOURCES = project.sv   # Specify xxx.sv even if the true source is xxx.tlv.

ifneq ($(GATES),yes)

# RTL simulation:
SIM_BUILD				= sim_build/rtl
VERILOG_SOURCES += $(addprefix $(SRC_DIR)/,$(PROJECT_SOURCES))
COMPILE_ARGS 		+= -I$(SRC_DIR)

else

# Gate level simulation:
SIM_BUILD				= sim_build/gl
COMPILE_ARGS    += -DGL_TEST
COMPILE_ARGS    += -DFUNCTIONAL
COMPILE_ARGS    += -DUSE_POWER_PINS
COMPILE_ARGS    += -DSIM
COMPILE_ARGS    += -DUNIT_DELAY=\#1
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/primitives.v
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# this gets copied in by the GDS action workflow
VERILOG_SOURCES += $(PWD)/gate_level_netlist.v

endif

# Include the testbench sources:
VERILOG_SOURCES += $(PWD)/tb.v
TOPLEVEL = tb

# MODULE is the basename of the Python test file
MODULE = test

# include cocotb's make rules to take care of the simulator setup (unless we're just building Verilog sources)
ifneq ($(MAKECMDGOALS),verilog)
include $(shell cocotb-config --makefiles)/Makefile.sim
endif



#-------------------
# For TL-Verilog.

# SystemVerilog from TL-Verilog, including installation of SandPiper-SaaS.
$(SRC_DIR)/%.sv: $(SRC_DIR)/%.tlv
	@pip show sandpiper-saas > /dev/null || (echo "Installing sandpiper-saas..." && pip install sandpiper-saas && touch ~/.makerchip_accepted)
	@pip show sandpiper-saas > /dev/null || (echo "Failed to install sandpiper-saas, please install manually." && exit 1)
	cd $(SRC_DIR) && sandpiper-saas -i '$(<F)' -o '$(@F)' --outdir . --inlineGen --noDirectiveComments --noline --clkAlways --bestsv --iArgs

#-------------------


# Use this target to ensure that Verilog "sources" are built, in case any are generated.
.PHONY: verilog
verilog: $(VERILOG_SOURCES)
