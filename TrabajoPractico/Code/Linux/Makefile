EXEC = TP21
ASMFILE = main.asm
OFILE = main.o

asm:
	nasm -f elf32 -o $(OFILE) $(ASMFILE)
gcc:
	gcc $(OFILE) -m32 -o $(EXEC)
run:
	./$(EXEC)
