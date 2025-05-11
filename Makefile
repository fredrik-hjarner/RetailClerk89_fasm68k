.PHONY: all fasm68k vasm clown hexdump

all: fasm68k hexdump

fasm68k:
	fasm68k src/RetailClerk89.X68 -e200 -v2 RetailClerk.bin

vasm:
	vasm -no-opt -Fbin -spaces -wfail -o RetailClerk.bin src/RetailClerk89.X68
	# vasm -Fbin -spaces -wfail -o RetailClerk.bin src/RetailClerk89.X68

clown:
	# -w silences warnings.
	clownassembler -c -w -o RetailClerk.bin -i src/RetailClerk89.X68

hexdump:
	xxd -b -c1 RetailClerk.bin | cut -d' ' -f2 > RetailClerk.hex
