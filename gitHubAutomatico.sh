#!/bin/bash

#	Para maiores informações sobre o arquivo leia
#		documentacao.txt
#
#	Para maiores informações sobre as versões leia
#		REAME
#
#	Você queria executar e não estar vendo esse código?!
#	  Então abra seu terminal e digite
#
# 		$ sudo chmod +x gitHubAutomatico.sh
#		$ sudo bash gitHubAutomatico.sh
#
#	Você queria mesmo ver o código?!
#	  Bem-vindo ao código criado para automatizar o processo do GitHub
#		Olhe e modifique ao seu gosto!

# -----Identificadores
#	Array de Configuracao (arrayConfig)
# 		0 - Versão do sistema
# 		1 - Primeira Execucao 1 sim 0 não
#		2 - Se já foi lido os dados de usuário e projeto
#		3 - Nome do Usuário
#		4 - Nome do projeto
#		5 - Ultima vez utilizado
#		6 - Regra de qual arquivos pode ser adicionado
#
#	Array de Titulo (ArrayTitulo)
#		0 - Se está no modo live
#		1 - Se está no modo automatico

arrayConfig=("1.9.1(unstable)" "1" "0" "" "" "01-04-2012" "*.*")
arrayTitulo=("GitHubAutomatico (live)" "GitHubAutomatico")
titulo=""

#---------------------------------------------------------------------------------------------
#---------------------------------------- Funções --------------------------------------------

function zenity_esta_instalado()
{	
	#Função que verifica se o Zenity está instado no sistema caso não encontre
	#	vai tentar instalar com o consentimento do usuário
	echo "GitHubAutomatico - Verificando se o zenity está instado no seus sistema..."
	dpkg -l | grep zenity
	if [ $? = "0" ] ; then
		echo "|--- Zenity encontrado!\n"
		clear
	else
		echo "|--- Zenity não encontrado. Deseja instalá-lo para continuar a usar o automatico.sh?!S/N\n"
		read pode
		if [ $pode = "S" -o $pode = "s" -o $pode = "SIM" -o $pode = "sim"];then
			sudo apt-get install zenity
		else
			echo "|--- infelizmente não foi possivel instalá-lo. O Automático será abortado!"
		fi
	fi
}

function is_root()
{
	#Verifica se o usuário está como root caso contrário aborta execução
	# do automatico.sh
	if [ "`id -u`" != 0 ] ; then
		echo "Você não é root! Esse bash precisa de privilégios"
		zenity --error --title "ROOT necessário!" --text="Execute esse bash no seu terminal como:\n\n$ sudo bash ${arrayConfig[1]}"
		exit
	fi
}

function leitura_de_configuracao()
{
	# Verifica se tem informações sobre o projeto no
	#	.config_automatico e envia as informações para
	#	o arrayConfig

	if [ -e ".config_automatico" ]; then
		#Se existe então carrega para dentro do array "arrayConfig"
		#	todas as informações que possui no sistema	
		echo "GitHubAutomatico - Fazendo o uplado do arquivo .config_automatico"	
		a=0
		while read linha 
		do 
			echo $linha
			arrayConfig[$a]="${linha}"
			let a++
		done < .config_automatico
		clear
	else
		aaa=$(zenity --info --text="Não existe um arquivo de configuracao!")
		echo "GitHubAutomatico - Atenção! Não existe o arquivo .config_automatico!"
	fi
}

function gravar_configuracoes()
{
		aaa=$(zenity --question --title ".config_automatico" --text "Deseja salvar as configuraçõs atuais?!")
		if [ ${?} = 0 ]; then
			touch .config_automatico
			chmod 777 .config_automatico
			for item in "${arrayConfig[@]}"; do
				echo "${item}" >> .config_automatico
			done
			aaa=$(zenity --info --text="Ok! Agora suas configurações foram salvas.")
			echo "GitHubAutomatico - Configurações salvas em .config_automatico!"
		else
			echo "GitHubAutomatico - Configurações não salvas"
		fi
}

function gerar_titulo()
{
	# Função que printa o cabeçalho
	
	if [ ${arrayConfig[1]} -eq "1" ]; then
		titulo=${arrayTitulo[0]}
	else
		titulo=${arrayTitulo[1]}
	fi
	echo "GitHubAutomatico - Titulo atribuido"
}

function criar_automatico()
{
	# Função responsável pela configuração e criação do automatico.sh
	#     segundo as configurações pré-colidas na função criar_projeto()
	
	clear
	cabeca
	echo "- Você  está  prestes a  cria um  automático para o seu -"
	echo "-    projeto.                                           -"
	echo "-    Você tem certeza disso? Y/N                        -"
	read enter
	if [ $enter = "Y" -o $enter = "y" ]; then
		clear
		criacao_projeto
		clear
		cabeca
		echo "- As configurações básicas  foram feitas,  agora  vamos -"
		echo "-    criar seu automatico.sh                            -"
		echo "-    |-0%                                        |      -"
		#Troca o valor para informar que autoself é o automatico
		sed "s/autoself=\"0\"/autoself=\"1\"/g" "creator.sh" > "temp1.sh"
		echo "-    |------------%25                            |      -"
		#coloca o valor do projeto no identificador
		sed "s/#project/project=\"$project\"/g" "temp1.sh" > "temp2.sh"
		echo "-    |--------------------%50                    |      -"
		#Coloca o valor do usuário no indentifador
		sed "s/#user/user=\"$user\"/g" "temp2.sh" > "temp3.sh"
		echo "-    |--------------------------------%75        |      -"
		#Troca o valor de lido para que o automatico.sh não leia novo nome de projeto
		sed "s/lido=0/lido=1/g" "temp3.sh" > "temp4.sh"
		echo "-    |-------------------------------------%90   |      -"
		
		if [ $criarpasta = "Y" -o $criarpasta = "y" ]; then
			cp temp4.sh ${project}/automatico.sh
			sudo chmod +x ${project}/automatico.sh
			rm temp*
			echo "-    |-------------------------------------------| %100 -"
			sleep 1
			if [ -f ${project}/automatico.sh ]; then
				echo "- Automatico.sh foi criado com sucesso!                 -"
			else
				echo "- ATENÇÃO!                                              -"
				echo "- Automatico.sh não foi criado por algum erro           -"
			fi
			
		else
			cp temp4.sh automatico.sh
			sudo chmod +x automatico.sh
			rm temp*
			echo "-    |-------------------------------------------| %100 -"
			sleep 1
			if [ -f "automatico.sh" ]; then
				cabeca
				echo "- Automatico.sh foi criado com sucesso!                 -"
			else
				cabeca
				echo "- ATENÇÃO!                                              -"
				echo "- Automatico.sh não foi criado por algum erro           -"
			fi
		fi
		
		echo "- Deseja sair? Y/N                                      -"
		leu=false
		while [ $leu = false ]; do
			read nada
			if [ -n "$nada" ];then
				leu=true
			fi
		done
		if [ $nada = "Y" -o $nada = "y" ]; then
			sair
		fi
	fi
	
	
}

function modo_live()
{
	
	# Função deficada apenas a executar funções basicas
	#	do github sem necessariamente a criação de um
	#	automatico.sh
	
	#Verifica se o nome do usuário e do projeto já foram
	#     lido, sendo lido passa direto para as funções.
	#	caso contrário vai ler os valores
					
	if [ ${arrayConfig[2]} = 0 ]; then
		leitura
	fi
	echo "GitHubAutomatico - Modo live está em execução"
	commit=$(zenity --title="${titulo}"  --entry --text "No live não é feita nenhuma configuração\n	Portanto para que funcione é necessário que o gitHub\n	já esteja previamente funcionando nesse local. Escolha a opção\n\n1 - Push\n2 - Pull\n	0 - Sair")
	if [ ${commit} = 1 ]; then
		git_push
	elif [ ${commit} = 2 ]; then
		git_pull
	fi
		
}

function about()
{
	# Função que trás informações a respeito do projeto
	
	texto="- O GitHubAutomatico é um programa em Bash que automatiza a suas tarefas no gitHub. Pode ser executado de forma \'live\' ou personalizar para seu projeto sem necessitar de reconfigurar novamente!\n\nO projeto pode ser baixado no seguinte link:\n	Http://github.com/glaucomunsberg/Automatico\nSua Versão:\n	${arrayConfig[0]}\nCriado por:\n	Glauco Roberto Munsberg dos Santos\n\nUltima Modificação na configuracao:\n	${arrayConfig[5]}"
	FILE=$(zenity --info --height=100 --width=450 --title="${titulo} - Sobre" --text="${texto}")
}

function sair()
{
	# Função que simplifica o processo de saida
	
	clear
	aaa=$(zenity --info --timeout=1 --text="Saindo do sistema...")
	clear;
	exit;
}

function leitura()
{
	#Função que faz a leitura das informações de nome e projeto
	# A função primeiro entra em um loop até que "certo" seja verdadeiro
	# para que isso ocorra então a leitura do nome e do projeto
	# tem que ser diferente de nulo.
	certo=false
	while [ $certo = false ]; do
		leu=false
		certo=false
		
		#ler o nome do USUARIO e manda para arrayConfig[3]
		echo "GitHubAutomatico - Fazendo a leitura do nome do usuário"
		while [ $leu = false ]; do
			arrayConfig[3]=$(zenity --title "${titulo}" --entry --text "Por favor para continuar, digite seu nome de USUÁRIO do github")
			if [ -n "${arrayConfig[3]}" ];then
				leu=true
			fi
		done
		
		#ler o nome do PROJETO e manda para arrayConfig[4]
		lido=0
		leu=false
		echo "GitHubAutomatico - Fazendo a leitura do nome do projeto"
		while [ $leu = false ]; do
			arrayConfig[4]=$(zenity --title "${titulo}" --entry --text "Por favor para continuar, digite seu nome do seu PROJETO do github")
			if [ -n "${arrayConfig[4]}" ];then
				leu=true
			fi
		done
		
		#Demonstra para o usuário as informações que ele passou e pede para confirmar.
		#	O texto é diferente para facilitar caso o usuário já tenha configurado antes
		if [ ${arrayConfig[1]} -eq 1 ]; then
			confirma=$(zenity --question --title="${titulo}" --text "Ok. Confira os dados, pois o gitHubAutomatico será\n configurado com as seguintes informações\n\nGitHub usuário:	${arrayConfig[3]}\nGitHub projeto:	${arrayConfig[4]}\n\nOs dados estão certos?!")
		else
			confirma=$(zenity --question --title="${titulo}" --text "Ok. Confira os dados para continuar.\nGitHub usuário:	${arrayConfig[3]}\n\nGitHub projeto:	${arrayConfig[4]}\n\nOs dados estão certos?!")
		fi
		if [ $? = "0" ]; then
			certo=true
			echo "GitHubAutomatico - Nome de usuário e projeto feita com sucesso"
		else
			${arrayConfig[3]}=""
			${arrayConfig[4]}=""
		fi
	done
	arrayConfig[2]="1"
}
function criacao_projeto()
{
	#Faz a leitura do nome do usuário e o nome do projeto
	#   que será utilizado pelo arquivo, bem como o as dependências
	#	do mesmo. Possibilita a criação de uma pasta para conter o
	#   projeto e configura a pasta segundo o projeto que será descarregado
	
	echo "- Ok.  Porém  é preciso de algumas informações:         -"
	echo "-    1) Seu projeto já teve algum commit? Y/N           -"
	read existe
	
	if [ $existe = "Y" -o $existe = "y" ]; then

		echo "- Ok.  Vamos  criar  TUDO, ou  seja, configuraremos seu -"
		echo "-    projeto, criaremos seu automatico  e seu  primeiro -"
		echo "-    commit. Mas antes disso vamos trazer seus arquivos -"
	else
		echo "- Ok.  Vamos  criar  TUDO, ou  seja, configuraremos seu -"
		echo "-    projeto, criaremos seu automatico  e seu  primeiro -"
		echo "-    commit.                                            -"
	fi
	
	#Verifica se o nome do usuário e do projeto já foram
	#     lido, sendo lido passa direto para as funções.
	#	caso contrário vai ler os valores
					
	if [ $lido = "0" ]; then
		leitura
	fi
	
	echo "- 4) Deseja criar uma pasta para os arquivos? Y/N.      -"
	read criarpasta
	
	if [ $criarpasta = "Y" -o $criarpasta = "y" ]; then

		echo "- Criada a pasta e configurando...                      -"
		mkdir ${project}
		cd ${project}/
	else
		echo "- Configurando...                                       -"
	fi
	
	if [ $existe = "N" -o $existe = "n" ]; then
		sudo git init
		touch README
		sudo git add README
		sudo git commit -m 'Conf. pelo GitHub Creator $version'
		sudo git remote add origin git@github.com:${user}/${project}.git
		sudo git push -u origin master
	else
		sudo git init
		sudo git remote add origin git@github.com:${user}/${project}.git
		sudo git pull git@github.com:${user}/${project}.git master
		if [ -f "README" ]; then
			sudo chmod 777 README
			gedit README
		else
			echo "- Não foi detectado o README utilizado no gitHub.       -"
			echo "- Deseja criar um para ser usado?!  Y/N                 -"
			read nada
			if [ $nada = "Y" -o $nada = "y" ]; then
				touch README
				gedit README
			fi
			git add *.*
			sudo git push -u origin master
		fi
	fi
	
	if [ $criarpasta = "Y" -o $criarpasta = "y" ]; then
		cd ../
	fi
	
	echo "---------------------------------------------------------"
	read nada
}

function git_push()
{
	#Função contendo o Push, 
	#	utilizado no github para empurrar os arquivos
	echo "GitHubAutomatico - Executando um Push"
	opcao=$(zenity --question --title="${titulo}" --text "Deseja alterar o conteúdo do README?")
	if [ $? = "0" ]; then
		gedit README
	fi
	#Coleta o nome do comit e faz as atribuições caso seja cancelado nada será feito
	nome=$(zenity --title "${titulo}" --entry --text "Insira o nome para o seu commit" --entry-text="versao")
	if [ $? != "1" ]; then
		git add README
		git add ${arrayConfig[6]};
		git commit -m ${nome// /_};
		echo "GitHubAutomatico - Commitando os arquivos..."
		#Antes de enviar ele apaga o log e com o comando >& ele vai mandar todas
		# as linhas que gerou para o arquivo .log
		touch .log
		git push origin master >& .log
	else
		zenity --info --title="${titulo}" --text="Commit abortado!"
	fi

}

function git_pull()
{
	# Função usado no git para puxar os arquivos
	# detecta se está tudo ok ou não
	
	
	echo "GitHubAutomatico - Puxando arquivos"
	touch .log
	sudo git pull git@github.com:${arrayConfig[3]}/${arrayConfig[4]}.git master >& .log
	
	retorno= grep "Already up-to-date." .log
	#Se e não foi encontrado então é pq foi enviado algo
	if [ "$retorno" = 1  ]; then
		zenity --info --text="Already up-to-date."
	else
		zenity --text-info --title="${titulo} log"--width=500 \ --height=400 --filename=".log"
	fi
}

function ssh_key()
{
	# Função para que se possa resetar o SSH e após fazer isso
	#     testa a conexão com o github
	echo "- Resetar SSH..                                         -"
	sudo systemctl restart sshd.service
	sleep 1
	sudo ssh -T git@github.com
	echo "---------------------------------------------------------"
	read nada
}

function git_remove()
{
	# Função que deleta os arquivos escolhidos nomeados pelo usuário
	
	echo "- Digite os arquivos que deseja deletar:                -"
	read removendo
	sudo git rm ${removendo}
	echo "---------------------------------------------------------"
	echo "- Commit para que que se delete os arquivos             -"
	echo "---------------------------------------------------------"
	read nada
}

function git_test()
{
	# Função de teste de conexão do projeto com o GitHub
	echo "---------------------------------------------------------"
	echo "- Teste de Conexão com o GitHub...                      -"
	sudo ssh -T git@github.com
	echo "---------------------------------------------------------"
	read nada
}

function git_add()
{
	# Função que adiciona os arquivos escolhidos nomeados pelo usuário
	
	echo "- Digite os arquivos que deseja adicionar:              -"
	read adicionar
	sudo git add ${adicionar}
	echo "---------------------------------------------------------"
	echo "- Commit para que adicione os arquivos                  -"
	echo "---------------------------------------------------------"
	read nada
}

function git_status()
{
	# Função de status do estado que se encontra os arquivo em relação
	#     ao estado do repositório segundo o último push/pull
	
	echo "--------------------------------------------------------"
	echo "- Git Status...                                        -"
	sudo git status
	echo "--------------------------------------------------------"
	read nada
}

function ferramentas()
{
	# Função que contém as ferramentas aninhadas para melhore ser
	#     melhor organizado o menu do automatico.sh. Trás nele a
	#     coleção de ferramentas integradas.
	echo "- 1. Git Remove                                         -"
	echo "- 2. Git Status                                         -"
	echo "- 3. Git Test                                           -"
	echo "- 4. Git Add                                            -"
	read nada
	case $nada in
		1) git_remove;;
		2) git_status;;
		3) git_test;;
		4) git_add;;
	esac
}

#---------------------------------------------------------------------------------------------
#--------------------------------------- Programa --------------------------------------------


zenity_esta_instalado
is_root

if [ -e ".config_automatico" ]; then
		#Existe configuracao
		leitura_de_configuracao
		gerar_titulo
		aaa=$(zenity --info --title="${titulo}" --width=300 --timeout=2  --text "Suas configurações foram carregas com sucesso!")
		#....
		
		
	else
		#Não existe Configuracao pergunta se quer executar em modo live ou criar projeto
		gerar_titulo
		oQueFazer=$(zenity 	--title="${titulo}" \
						--width=300 \
						--entry --text "Bem-Vindo ao GitHubAutomatico!\n\n	1 - Rodar em Modo Live\n	2 - Criar um gitHubAutomatico.sh\n	3 - Sobre\n	4 - Sair")	
		if [ "${?}" = "1" ]; then
			sair
		else
			case $oQueFazer in
				1) modo_live;;
				2) criar_automatico;;
				3) about;;
				4) sair;;
			esac
		fi
fi
