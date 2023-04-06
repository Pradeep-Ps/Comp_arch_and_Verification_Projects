#rm *.exe;
all:clean	compile	execute

clean:rm *.exe
	echo "Removed *.exe"

compile:gcc MIPS.c -o MIPS.exe
	echo "trace.txt"

execute:./MIPS.exe;
	echo "trace.txt"
	trace.txt
