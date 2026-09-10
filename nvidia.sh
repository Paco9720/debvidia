#!/bin/bash

# Script para instalar NVIDIA de forma sencilla en Debian
# NO modifica repos — solo continúa si están activados

echo "Comprobando repositorios..."

# Detectar si existen las secciones necesarias
if grep -E "main(.*)(contrib)(.*)(non-free)(.*)(non-free-firmware)" /etc/apt/sources.list > /dev/null; then
    echo "Repositorios 'contrib', 'non-free' y 'non-free-firmware' detectados."
else
    echo "======================================================================"
    echo "❌ Los repositorios necesarios NO están habilitados."
    echo ""
    echo "Actívalos manualmente editando /etc/apt/sources.list"
    echo "Debes agregar: contrib non-free non-free-firmware"
    echo ""
    echo "Ejemplo de línea correcta:"
    echo "deb http://deb.debian.org/debian/ trixie main contrib non-free non-free-firmware"
    echo ""
    echo "Después ejecuta: sudo apt update"
    echo "======================================================================"
    exit 1
fi

echo "Actualizando la lista de paquetes..."
sudo apt update

echo "Instalando dependencias necesarias..."
sudo apt install -y linux-headers-$(uname -r) build-essential dkms

echo "Instalando el controlador NVIDIA y firmware..."
sudo apt install -y nvidia-driver firmware-misc-nonfree

echo "Deshabilitando el controlador Nouveau..."
echo -e "blacklist nouveau\noptions nouveau modeset=0" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf > /dev/null
sudo update-initramfs -u

#echo "Configurando NVIDIA para Wayland..."

#sudo tee /etc/modprobe.d/nvidia-wayland.conf > /dev/null <<'EOF'
#options nvidia-drm modeset=1
#options nvidia-drm fbdev=1
EOF

echo ""
echo "======================================================================"
echo "Instalación completada."
echo "Reinicia el sistema para que los cambios surtan efecto:"
echo "sudo reboot"
echo "======================================================================"

