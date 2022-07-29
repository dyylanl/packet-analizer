#!/bin/bash

greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#
export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour}Saliendo${endColour}"
	exit 0
}

function helpPanel(){
    echo -e "\n\t${purpleColour}a)${endColour}${yellowColour} Modo de ataque${endColour}"
	echo -e "\t\t${redColour}Handshake${endColour}"
	echo -e "\t\t${redColour}PKMID${endColour}"
	echo -e "\t${purpleColour}p)${endColour}${yellowColour} Puerto${endColour}"
	echo -e "\t${purpleColour}h)${endColour}${yellowColour} Mostrar este panel de ayuda${endColour}\n"
    exit 0
}

function dependencies(){
	tput civis
	clear
    dependencies=(nmap)

	echo -e "${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios...${endColour}"
	sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColour}[*]${endColour}${blueColour} Herramienta${endColour}${purpleColour} $program${endColour}${blueColour}...${endColour}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColour}(V)${endColour}"
		else
			echo -e " ${redColour}(X)${endColour}\n"
			echo -e "${yellowColour}[*]${endColour}${grayColour} Instalando herramienta ${endColour}${blueColour}$program${endColour}${yellowColour}...${endColour}"
			apt-get install $program -y > /dev/null 2>&1
		fi; sleep 1
	done
}

function startAttack(){

		clear
		echo -e "${yellowColour}[*]${endColour}${grayColour} Configurando nmap con el puerto indicado...${endColour}\n"
		
	if [ "$(echo $attack_mode)" == "Handshake" ]; then #allports

		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Nombre del punto de acceso: ${endColour}"
		echo -e "\n${yellowColour}[*]${endColour}${grayColour} Canal del punto de acceso: ${endColour}"

	elif [ "$(echo $attack_mode)" == "PKMID" ]; then ##selected_port
		clear
        echo -e "${yellowColour}[*]${endColour}${grayColour} Iniciando ClientLess PKMID Attack...${endColour}\n"
		sleep 2

	else
		echo -e "\n${redColour}[*] Este modo de ataque no es válido${endColour}\n"
	fi
}

# Main Function
total_params=2
if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0
    while getopts ":a:p:h:" arg; do
		case $arg in
			a) attack_mode=$OPTARG; let parameter_counter+=1 ;;
			p) networkCard=$OPTARG; let parameter_counter+=1 ;;
			h) helpPanel;;
		esac
	done

	if [ $parameter_counter -ne $total_params ]; then
		helpPanel
        tput cnorm
	else
		dependencies
		startAttack
        tput cnorm
	fi
else
	echo -e "\n${redColour}[*] No soy root${endColour}\n"
fi