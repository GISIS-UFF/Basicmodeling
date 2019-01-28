modeling_basic:		modeling_basic.o
	gfortran modeling_basic.o -o modeling_basic

modeling_basic.o:	modeling_basic.f90
	gfortran -c modeling_basic.f90

clean:
	rm *.o modeling_basic

help:
	@echo "Makefile do arquivo modeling_basic.f90"
