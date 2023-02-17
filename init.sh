#!/bin/bash
# --------------------------------- FASE 1 ==> ACTUALZIAR SISTEMA -------------------------------- #

# Actualiza los repositorios
sudo apt update

# Actualiza los paquetes instalados
sudo apt full-upgrade -y

# Limpia los paquetes obsoletos y los archivos temporales
sudo apt autoremove -y
sudo apt autoclean -y

# Actualiza la distribución KDE neon
sudo pkcon refresh -y
sudo pkcon update -y

# Limpia los archivos temporales de la distribución KDE neon
sudo pkcon repair -y

# Muestra un mensaje de confirmación
echo "El sistema ha sido actualizado correctamente."


# --------------------------- FASE 2 ==> CLONAR REPOSITORIO PARA SETUP --------------------------- #

# Verificar si el usuario actual es root
if [[ $EUID -eq 0 ]]; then
   read -p "Este script debe ejecutarse con el usuario normal. Por favor, ingrese el nombre de usuario: " username
   userhome=$(eval echo "~$username")
else
   userhome=$(eval echo "~")
fi

# Verificar si la carpeta Downloads existe en la ruta del usuario actual
if [ ! -d "$userhome/Downloads" ]; then
    echo "La carpeta Downloads no existe en la ruta del usuario actual. Se creará la carpeta Downloads en $userhome."
    mkdir "$userhome/Downloads"
fi

# Verificar si el repositorio ya ha sido clonado en la carpeta Downloads
if [ -d "$userhome/Downloads/kde_setup" ]; then
    echo "El repositorio ya ha sido clonado en la carpeta Downloads. Se eliminará el repositorio existente."
    rm -rf "$userhome/Downloads/kde_setup"
fi

# Clonar el repositorio en la carpeta Downloads
echo "Clonando el repositorio kde_setup en la carpeta Downloads del usuario actual."
git clone https://gitlab.com/artoria026/kde_setup.git "$userhome/Downloads/kde_setup"

# Clonar el repositorio en la ruta actual
git clone https://github.com/wsdfhjxc/virtual-desktop-bar "$userhome/Downloads/virtual-desktop-bar"
# Cambiar al directorio del repositorio clonado
cd virtual-desktop-bar
# Ejecutar el script install-applet.sh
sudo ./scripts/install-dependencies-ubuntu.sh
sudo ./scripts/install-applet.sh

# Volver a la ruta anterior y eliminar el repositorio y todas las subcarpetas
cd ..
rm -rf virtual-desktop-bar


# ------------------------------------- FASE FINAL ==> LISTO! ------------------------------------ #
sudo apt install neofetch -y
neofetch
echo "El proceso de instalacion ha Finalizado!"