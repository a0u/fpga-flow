basedir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
basedir := $(basedir:/=)
commondir := $(basedir)/common

BOARD ?= zedboard
boarddir := $(basedir)/$(BOARD)
projdir := $(CURDIR)/project/$(BOARD)

VIVADO ?= /opt/Xilinx/Vivado/2018.1/bin/vivado
VIVADOFLAGS := \
	-nojournal -log $(BOARD).log -mode tcl \
	-source $(boarddir)/tcl/board.tcl \
	-source $(commondir)/tcl/init.tcl

.SUFFIXES:

ipstamp := $(projdir)/bd/.stamp
$(ipstamp): $(commondir)/tcl/bd.tcl
	$(VIVADO) $(VIVADOFLAGS) $(foreach f,$^,-source $(f))
	touch $@

.PHONY: ip
ip: $(ipstamp)

.PHONY: bit
bit: $(commondir)/tcl/impl.tcl $(ipstamp)
	$(VIVADO) $(VIVADOFLAGS) -source $<

.PHONY: clean
clean::
	rm -rf -- $(projdir) .Xil/ *.log *.jou *.str
