#/bin/bash

#Script para instalalar nvidia de forma sencilla

echo "Actualizando la lista de paquetes..."
sudo apt update

echo "Instalando dependencias necesarias..."
sudo apt install -y linux-headers-$(uname -r) build-essential dkms

echo ""
echo "======================================================================"
echo "¿Deseas activar los repositorios 'non-free' y 'non-free-firmware' y refrescar los repositorios? (s/n)"
read -p "" -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]
then
    echo "Activando repositorios 'non-free' y 'non-free-firmware'..."
    sudo sed -i 's/main/main contrib non-free non-free-firmware/g' /etc/apt/sources.list
    echo "Refrescando la lista de paquetes..."
    sudo apt update
else
    echo "Por favor, asegúrate de que los repositorios 'non-free' y 'non-free-firmware' estén habilitados en /etc/apt/sources.list manualmente."
    echo "Por ejemplo, una línea debería verse así: deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware"
    echo "Si no está habilitado, edita el archivo y luego ejecuta 'sudo apt update' manualmente antes de continuar."
    echo "Presiona Enter para continuar..."
    read -p ""
fi

echo "Instalando el controlador NVIDIA y firmware..."
sudo apt install -y nvidia-driver firmware-misc-nonfree

echo "Deshabilitando el controlador Nouveau..."
echo "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf > /dev/null
sudo update-initramfs -u

echo "La instalación ha finalizado. Por favor, reinicia tu sistema para que los cambios surtan efecto."
echo "sudo reboot
"
