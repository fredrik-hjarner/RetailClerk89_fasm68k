.PHONY: all fasm68k vasm clown diff diff-count

all: fasm68k

fasm68k:
	sleep 1
	fasm68k src/RetailClerk89.X68 -e200 -v2 fasm68k_artifacts/RetailClerk.bin
	sleep 1
	xxd -b -c1 fasm68k_artifacts/RetailClerk.bin | cut -d' ' -f2 > fasm68k_artifacts/RetailClerk.hex
	sleep 1
	git diff --no-index vasm_artifacts/RetailClerk.hex fasm68k_artifacts/RetailClerk.hex | wc -l > diffing_lines.txt

vasm:
	vasm -noialign -L vasm_artifacts/RetailClerk.lst -no-opt -Fbin -spaces -wfail -o vasm_artifacts/RetailClerk.bin src/RetailClerk89.X68
	xxd -b -c1 vasm_artifacts/RetailClerk.bin | cut -d' ' -f2 > vasm_artifacts/RetailClerk.hex

# clownassembler can't assemble RetailClerk.
clown:
	# -w silences warnings.
	clownassembler -c -w -o RetailClerk.bin -i src/RetailClerk89.X68

diff:
	git diff --no-index vasm_artifacts/RetailClerk.hex fasm68k_artifacts/RetailClerk.hex

diff-count:
	git diff --no-index vasm_artifacts/RetailClerk.hex fasm68k_artifacts/RetailClerk.hex | wc -l
