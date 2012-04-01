#!/bin/bash
arrayConfig=("0.9" "creator.sh" "Y" "0" "titulo" "" "")
function leituraDeArquivo()
{
	a=0
	while read linha 
	do 
		echo $linha
		array[$a]="${linha}"
		let a++
	done < .config_automatico
}

function zenity_func()
{	
	#Calendário
	aaa=$(zenity --title="Escolha a data" --calendar --day=31 --month=12 --year=2007)

	#Leitura de Dado
	aaa=$(zenity --title "Digite o IP da máquina que você deseja pingar" --entry --text " ")

	#Lista
	aaa=$(zenity --list --checklist --column "Comprar" --column "Item" TRUE Maçã TRUE Laranja FALSE Peras FALSE Uvas)

	#Seleção de Arquivo
	aaa=$(zenity --title="Selecione o arquivo a ser removido" --file-selection)
	
	#ou 
	aaa=$(zenity --file-selection --save --confirm-overwrite);echo $szSavePath
	echo $aaa

	#Caixa de Yes/No
	aaa=$(zenity --question --title "Cuidado !" --text "Usuário encontrado, deseja removê-lo ?")

	#Pesquisa
	find . -name *.* | zenity --list --title "Busca por resultados" --text "Procurando todos as MP3.." --column "Arquivos"
	
	#Erro
	aaa=$(zenity --error --title "ROOT necessário!" --text="Execute esse bash no seu terminal como")
	
}

function is_root()
{
	#Verifica se o usuário está como root caso contrário aborta execução
	# do automatico	
	if [ "`id -u`" != 0 ] ; then
		zenity --error --title "ROOT necessário!" --text="Execute esse bash no seu terminal como:\n\n$ sudo bash ${arrayConfig[1]}"
	fi
}
aaa=$(zenity --question --title "Cuidado !" --text "Usuário encontrado, deseja removê-lo ?")
echo $?
