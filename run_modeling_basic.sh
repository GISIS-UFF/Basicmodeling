#!/bin/bash
#
# run_modeling_basic.sh (Shell Script)
#
# Necessita do pacote Seismic Unix instalado para visualização
#
# Objetivo: Basic acoustic wave equation modeling.
#
# Versão 2.0 (Modificada)
#
# Original: Felipe Timóteo 08/01/2019
#
# Programador: Rodolfo A. C. Neves 14/01/2019
# 
# email: rodolfo_profissional@hotmail.com
# 
# Licença: Software de uso livre e código aberto.

#----------------{ Configuração de variáveis }-----------------------------#

# Versão deste programa
VERSAO="Versão 2.0"

#--------------------------------------------------------------------------#

MENSAGEM_USO="
$(basename $0) [-h | -v | -c | -e | -r ]
-h --help Exibe esta mensagem de ajuda e sai
-v --version Exibe a Versão do programa e sai
-c Compila os arquivos necessários deste programa em fortran 90
-e Executar programa de modelagem
-r Remover arquivos .bin 
Exemplo de uso: 
	bash$ $0 -c # Compilar arquivos .f90
	bash$ $0 -e # Executar programa
	bash$ $0 -r # Remover arquivos .bin
"
# Verificar se o usuário forneceu algum parâmetro
[ -z "$1" ] && {
	echo "O usuário não forneceu nenhum parâmetro!" 
	echo "Digite $0 -h para obter ajuda!" 
	exit 1 
}

case "$1" in
-h | --help) ## Exibir ajuda
	echo -e "$MENSAGEM_USO"
	exit 0
;;

-v | --version) ## Exibir versão
	echo "$VERSAO"
	exit 0
;;

-c) ## Compilação

	# Compilação com arquivo Makefile
	make 

	exit 0

;;

-e) ## Rodar modeling_basic

	./modeling_basic

	# Visualizar (TODO:Basta descomentar)
	
	#Snapshots
	#xmovie n1=301 n2=301 sleep=1 loop=1 < snapshots.bin

	#Seismogram
	#ximage n1=1001 < seismogram.bin

	exit 0
;;

-r) ## Opção para remover arquivos .bin 

	rm *.bin 
	
	exit 0

;;
*) ## Usuário forneceu parâmetro desconhecido
	echo -e "\033[31mERRO: Opção $1 desconhecida!\033[m"
	echo "\033[31mDigite $0 -h para obter ajuda\033[m"
	exit 3
;;
esac
