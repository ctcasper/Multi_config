#!/bin/bash
################# funciones para agregar los comandos a los scripts expect de cada marca/tipo de equipo #########
EXP="/home/local/********/christopher.casper/DEVICE-MULTI-CONFIG/exp/"
VAR="/home/local/********/christopher.casper/DEVICE-MULTI-CONFIG/var/"
function ADD_COMMAND_FORTIGATE(){
echo
echo
cp $EXP"configure-Fortigate.exp" $EXP"configure-Fortigate-Temp.exp"
read -p "Escribi el comando que queres ejecutar:  " fw
sed -i '36s/.*/send "'"$fw"'&/' $EXP"configure-Fortigate-Temp.exp"
}

function ADD_COMMAND_JUNIPER(){
echo
echo
echo " 1 - Firewall "
echo " 2 - Switch"
echo
cp $EXP"configure-Juniper.exp" $EXP"configure-Juniper-Temp.exp"
read -p "Que tipo de equipo es?: " input
if [[ $input == 1 ]] 
	then
	read -p "Escribi el comando que queres ejecutar:  " fw
	sed -i '36i send "'"$fw"' '/''n'"' $EXP"configure-Juniper-Temp.exp"
	if [[ $input == 2 ]] 
	then
	read -p "Escribi el comando que queres ejecutar:  " sw
	sed -i '42i send "'"$sw"' '/''n'"' $EXP"configure-Juniper-Temp.exp"
	fi
	fi
}

function ADD_COMMAND_CISCO(){
echo
echo
cp $EXP"configure-cisco.exp" $EXP"configure-cisco-Temp.exp"
read -p "Escribi el comando que queres ejecutar: " input
sed -i '52i send "'"$input"' '/''n'"' $EXP"configure-cisco-Temp.exp"
}
#############################################################################################################################################################################################################################################
########## funcion para Confirmar que todos los datos ingresados sean correctos ###################
function CHECK_YORN(){
echo
echo
echo
read -p "Estas seguro que son correctos los datos ingresados? Y/N " -n 1 -r
echo -ne '\n'
if [[ $REPLY =~ ^[Yy]$ ]]
	then
	echo
	echo "Agregando equipos...."
	sleep 1
	echo "Equipos agregados correctamente!"
	sleep 1
	else
	echo
	echo
		echo "Algo fue mal, por favor volve a ejecutar el script"
		exit 0
	fi
	}

#############################################################################################################################################################################################################################################
################### funciones para agregar las ips de los equipos y ejecutar el script expect ###################
function ADD_Device_Fortigate(){
done=1
cat /dev/null > $VAR"device-list.txt"
echo
echo
ADD_COMMAND_FORTIGATE
echo "Ingresa las IP de los equipos y luego presiona ENTER 2 veces (agregalos con copy/paste): " ""
while read -r input
do 
	echo $input >> $VAR"device-list.txt"
        if [[ $input == "" ]];then
	#CHECK_YORN
        for device in `cat /home/local/********/christopher.casper/DEVICE-MULTI-CONFIG/var/device-list.txt` $(seq $done); do
        ./exp/configure-Fortigate-Temp.exp $device $s $e $user; #llama a expect fortigate
done                
        fi
done
}


function ADD_Device_Cisco(){
cat /dev/null > $VAR"device-list.txt"
echo
echo
echo "Ingresa las IP de los equipos y luego presiona ENTER 2 veces (agregalos con copy/paste): " ""
while read -r input
do 
	echo $input >> $VAR"device-list-cisco.txt"
        if [[ $input == "" ]];then
	ADD_COMMAND_CISCO
	CHECK_YORN
        for device in `cat /home/local/*******/christopher.casper/DEVICE-MULTI-CONFIG/var/device-list.txt`; do
        ./exp/configure-cisco-Temp.exp $device $s $e $user; #llama a expect cisco
done                
        fi
done
}


function ADD_Device_Juniper (){
cat /dev/null > $VAR"device-list.txt"
echo
echo
echo "Ingresa las IP de los equipos y luego presiona ENTER 2 veces (agregalos con copy/paste): " ""
while read -r input
do 
	echo $input >> $VAR"device-list-cisco.txt"
        if [[ $input == "" ]];then
	ADD_COMMAND_JUNIPER
	CHECK_YORN
        for device in `cat /home/local/*********/christopher.casper/DEVICE-MULTI-CONFIG/var/device-list.txt`; do
        ./exp/configure-Juniper-Temp.exp $device $s $user; #llama a expect juniper
done
        fi
done

}

#############################################################################################################################################################################################################################################

function CISCO(){
 tput cup 1 58
 echo -en '\E[47;42m'"\033[1mDEVICE MULTI-CONFIGURATOR\033[0m"
 echo
 echo
 echo
 echo
 echo	"CONFIGURANDO EQUIPOS CISCO"
 echo
 echo -n "Ingresa tu usuario: "
 read user
 echo -n "Ingresa la clave SSH $user: "
 read -s s
 echo -ne '\n'
 echo -n "Ingresa la clave Enable: " #Para no tener que poner la clave en texto plano
 read -s e
 echo -ne '\n'
 ADD_Device_Cisco
 }
 
function JUNIPER(){
 tput cup 1 58
 echo -en '\E[47;42m'"\033[1mDEVICE MULTI-CONFIGURATOR\033[0m"
 echo
 echo
 echo
 echo
 echo   "CONFIGURANDO EQUIPOS JUNIPER"
 echo
 echo -n "Ingresa tu usuario: "
 read user
 echo -n "Ingresa la clave SSH de $user "
 read -s s
 echo -ne '\n'
 ADD_Device_Juniper
 }

function FORTIGATE(){
 tput cup 1 58
 echo -en '\E[47;42m'"\033[1mDEVICE MULTI-CONFIGURATOR\033[0m"
 echo
 echo
 echo
 echo   "CONFIGURANDO EQUIPO FORTIGATE"
 echo
 echo -n "Ingresa tu usuario: "
 read user
 echo -n "Ingresa la clave SSH de $user "
 read -s s
 echo -ne '\n'
 ADD_Device_Fortigate
 }

#############################################################################################################################################################################################################################################

clear
tput cup 1 58
echo -en '\E[47;42m'"\033[1mDEVICE MULTI-CONFIGURATOR\033[0m"
tput cup 5 65
tput setb 4
echo	"1 - CISCO"
echo
tput cup 7 68
echo	"2 - JUNIPER"
echo
tput cup 9 71
echo "3 - FORTIGATE"
echo
tput cup 11 74
echo	"4 - EXIT"
echo
tput cup 13 20
echo -e "Elegi el tipo de dispositivo a configurar: "
tput cup 13 62
read x
	if [[ "$x" = "4" ]]; then
		echo
		echo "exiting..."
		sleep 1
		clear
		exit
	elif [[ "$x" > "4" ]];
		then
		echo "Esa opcion no existe"
		echo
		echo
		exit 
fi
case $x in
     1) 
	 clear
	 CISCO
		echo "Eliminando archivos temporales....."
		sleep 1
		rm $EXP"configure-cisco-Temp.exp"
		echo "Hasta luego!"
	 ;;
	 2)
	 clear
	 JUNIPER
		echo "Eliminando archivos temporales....."
		sleep 1
		rm $EXP"configure-Juniper-Temp.exp"
		echo "Hasta luego!"
	 ;;
		3)
		clear
		FORTIGATE
		echo "Eliminando archivos temporales....."
		sleep 1
		rm $EXP"configure-Fortigate-Temp.exp"
		echo "Hasta luego!"
		;;
	 
esac

