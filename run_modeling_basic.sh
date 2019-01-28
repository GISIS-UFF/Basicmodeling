#!/bin/bash
#
# run_modeling_basic.sh (Shell Script)
#
# It's necessary Seismic Unix package to visualization
# Necessita do pacote Seismic Unix instalado para visualização
#
# Main program: Basic acoustic wave equation modeling.
#
# Versão 0.01
#
# author: Felipe Timóteo | felipetimoteo@id.uff.br
#
# updated by: Rodolfo A. C. Neves | rodolfo_profissional@hotmail.com
# 
# Licença: Software de uso livre e código aberto.

#--------------------------------------------------------------------------#
# Versão deste programa
VERSAO="Versão 0.01"
#--------------------------------------------------------------------------#

MENSAGEM_USO="
$(basename $0) [-h | -v | -c | -e | -r ]
-h --help    Show all instructions
-v --version Show the version
-c           Compiling the modeling program
-e           Execute seimic modeling program
-p           Visualize modeling and show seismogram
-r           Clean files .bin 
Usage: 
	bash$ $0 -c # Compile files .f90
	bash$ $0 -e # Execute program
	bash$ $0 -r # Plot results
	bash$ $0 -r # Clean files .bin
"
# Check if user provide some parameter
[ -z "$1" ] && {
	echo "The user doesn't provide any parameter" 
	echo "Type $0 -h for more info" 
	exit 1 
}

case "$1" in
-h | --help) ## Show help
	echo -e "$MENSAGEM_USO"
	exit 0
;;

-v | --version) ## Show version
	echo "$VERSAO"
	exit 0
;;

-c) ## Compiling

	# Makefile compiling
	make 

	exit 0

;;

-e) ## run main program

	./modeling_basic
	echo ""
	echo "To visualize the results you'll need Seismic Unix package"
	echo "Run $0 -p to plot the results"
	echo ""
	exit 0

;;

-p)
	## Visualization
	
	#Snapshots
	xmovie n1=301 n2=301 sleep=1 loop=1 < snapshots.bin

	#Seismogram
	ximage n1=1001 < seismogram.bin perc=99

	exit 0
;;

-r) ## Opção para remover arquivos .bin 

	rm *.bin 
	
	exit 0

;;
*) ## Message for bad parameter
	echo -e "\033[31mERRO: Option $1 unknown!\033[m"
	echo -e "\033[31mType $0 -h for help \033[m"
	exit 3
;;
esac
