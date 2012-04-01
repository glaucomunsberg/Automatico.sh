#!/bin/bash

#Versão 0.6

start=true
while [ $start = true ]; do
	clear
	echo "-------------------------------------------------"
	echo "                      GITHUB                     "
	echo "-------------------------------------------------"
	echo "1- Push                                         -"
	echo "2- Pull                                         -"
	echo "3- Options                                      -"
	echo "0- Sair                                         -"
	read commit
	case $commit in
		0)	clear
			echo "-------------------------------------------------";
			echo "                      GITHUB                     ";
			echo "-------------------------------------------------";
			echo "- Saindo...                                     -";
			sleep 1;
			clear;
			exit;;
			
		1)	echo "- Deseja inserir algo no README? S/N            -";
			read opcao;
			#
			if [ "S" = "$opcao" ]; then
				nano README
			fi
			#
			echo "- Carregando os arquivos...                     -";
			git add README;
			git add *.*;
			echo "- Insira o nome do commit:                      -";
			read nome;
			git commit -m ${nome// /_};
			clear;
			echo "- Commintando...                                -";
			git remote add origin git@github.com:user/projeto.git;
			git push origin master;
			echo "-------------------------------------------------";
			echo "-                  Commitado!                   -";
			echo "-------------------------------------------------";
			read nada;;
		2)	clear;
			echo "-------------------------------------------------";
			echo "- Github Pull...                                -";
			git remote add drnic git://github.com/user/projeto.git
			git pull
			echo "-------------------------------------------------";
			read outros;;
		3)	clear
			echo "-------------------------------------------------"
			echo "                      GITHUB                     "
			echo "-------------------------------------------------"
			echo "1- Resetar SSH service                          -"
			echo "2- Testa de conexão                             -"
			echo "3- Git Status                                   -"
			echo "4- Git Tag                                      -"
			echo "0- Sair                                         -"
			read outros
			case $outros in
				1)	clear;
					echo "-------------------------------------------------";
					echo "- Resetando SSH...                              -";
					sudo systemctl restart sshd.service;
					sleep 1;
					sudo ssh -T git@github.com
					echo "-------------------------------------------------";
					read outros;;
				2) 	clear;
					echo "-------------------------------------------------";
					echo "- Teste de Conexão..                            -";
					sudo ssh -T git@github.com
					echo "-------------------------------------------------";
					read outros;;
				3) 	clear;
					echo "-------------------------------------------------";
					echo "- Status...                                     -";
					sudo git status
					echo "-------------------------------------------------";
					read outros;;
				4) 	clear;
					echo "-------------------------------------------------";
					echo "- Insira o nome da tag para o commit            -";
					read nome;
					echo "- insira uma descrição para a tag               -";
					read outros;
					git tag -a ${nome// /_} -m ${outros// /_};
					echo "-------------------------------------------------";
					read outros;;
				0) 
					clear
					echo "-------------------------------------------------";
					echo "                      GITHUB                     ";
					echo "-------------------------------------------------";
					echo "- Saindo...                                     -";
					sleep 1;
					clear;
					exit;;
			esac
	esac
done
