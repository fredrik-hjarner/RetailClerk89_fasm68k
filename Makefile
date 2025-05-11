.PHONY: fasm68k vasm clown diff

all: fasm68k

fasm68k:
	fasm68k src/RetailClerk89.X68 -e200 -v2 fasm68k_artifacts/RetailClerk.bin
	xxd -b -c1 fasm68k_artifacts/RetailClerk.bin | cut -d' ' -f2 > fasm68k_artifacts/RetailClerk.hex

vasm:
	vasm -noialign -L vasm_artifacts/RetailClerk.lst -no-opt -Fbin -spaces -wfail -o vasm_artifacts/RetailClerk.bin src/RetailClerk89.X68
	xxd -b -c1 vasm_artifacts/RetailClerk.bin | cut -d' ' -f2 > vasm_artifacts/RetailClerk.hex

# clownassembler can't assemble RetailClerk.
clown:
	# -w silences warnings.
	clownassembler -c -w -o RetailClerk.bin -i src/RetailClerk89.X68

diff:
	git diff -no-index vasm_artifacts/RetailClerk.hex fasm68k_artifacts/RetailClerk.hex
