# MARS is pre-installed (/usr/local/bin/mars) on VM. Non-VM users should use
# MARS_PATH := java -jar path/to/Mars4_5.jar
MARS_PATH := mars
MARS_OPTS := a  mc CompactTextAtZero
MARS      := $(MARS_PATH) $(MARS_OPTS)

PROGRAMS := add_sub_test yeet
assemble:
	$(foreach prog,$(PROGRAMS),$(MARS) dump .text HexText $(prog).text.hex $(prog).asm;)
	$(foreach prog,$(PROGRAMS),$(MARS) dump .data HexText $(prog).data.hex $(prog).asm;)

clean:
	-rm -f $(ALLMEM)

.PHONY: assemble clean
