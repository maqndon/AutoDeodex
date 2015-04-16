#!/bin/bash
# Script para automatizar el deodexado de la carpeta /system/framework y /system/app
#Creado por Marcel Caraballo maqndon@gmail.com
#themuopenproject.org.ve, @muopenproject

## HOW TO
## Copiar el contenido de las carpetas /system/framework y /system/app a un directorio de trabajo
## con los nombres framework y app respectivamente. Copiar este archivo (auto.sh) en dichas carpetas.
## Darle permisos de ejecución (chmod +x auto.sh)
##

#limpiamos la pantalla
clear

#archivos a deodexar
lista='ls *.odex'
DIR=$(pwd | grep app)

#direccion de la carpeta framework
#cuando trabajamos en el directorio framework usamos framework-self='.'
framework='../framework'
frameworkSelf='.'

#ice cream sandwich revision 4.0.3
revision='15'


for odex in $lista; do

if [ $odex != ls ];then
	
	#mensaje del archivo actual que se esta deodexando
	echo deodexando: $odex

	#nombre del directorio que se va a crear la carpeta deodexada
	#dir=$(echo $odex|cut -f1 -d".")
	dir=$(echo $odex| sed 's/.....$//g')

	#orden para deodexar
	
	if [ -f $DIR ];then
	
	baksmali -a $revision -x $odex -d $frameworkSelf -o $dir
	else
	baksmali -a $revision -x $odex -d $framework -o $dir
	fi	

	if [ $? -ne 0 ]; then

		echo -e "Ha ocurrido un error al deodexar" $odex

		else
		
		smali $dir -o classes.dex
		if [ -f $DIR ];then
		#agregamos el archivo generado al 
		zip -r $dir.jar classes.dex
		#borramos archivos transitorios
		rm classes.dex
		rm $odex
		rm -r $dir
		echo -e "El archivo" $odex "se ha deodexado correctamente"
		else
		#agregamos el archivo generado al 
		zip -r $dir.apk classes.dex
		#borramos archivos transitorios
		rm classes.dex
		rm $odex
		rm -r $dir
		echo -e "El archivo" $odex "se ha deodexado correctamente"
		fi	
		
	fi
fi

#contamos los archivos a deodexar
cont=$((cont+1));

done

#echo -e "\n hubo" $cont "error(es) \n"

exit 1
