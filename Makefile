# Makefile to compile and run
# Some tips
# ‘%’ pega o stem (tronco) do nome
# $@ pega o nome do target e 
# $< pega o nome do primeiro pré-requisito
# $^ para listar todos os pré-requisitos do targe
#
# source:https://www.embarcados.com.br/introducao-ao-makefile/

# source files
SRC=$(wildcard *.f90)

# Object files
OBJ=$(SRC:.f90=.o)

# Executable files
EXE=$(SRC:.f90=.exe)

# Compilation parameters
COMPILER=gfortran
FLAGS=-O3

# Compilation and linking
all: $(EXE)

%.exe: %.o
	$(COMPILER) -o $@ $< $(FLAGS)
	
%.o: %.f90
	$(COMPILER) -o $@ $< -c $(FLAGS)

clean:
	@echo "Removing temporaly files ..."
	rm -rf *.o *.mod *~ *.bin *.exe

run:
	@echo "Running program ... "
	./modeling_basic.exe

seismogram:
	@echo "Ploting seismogram n1 = 1001"
	ximage n1=1001 < seismogram.bin perc=99

snapshots:
	@echo "Ploting snapshot n1= 301 n2=301 "
	xmovie n1=301 n2=301 sleep=1 loop=2 < snapshots.bin