#!/bin/bash

echo "--------------------------------------"    
echo "Установка пакетов для основных инструментов сборки!"
echo "--------------------------------------"    
# Основные инструменты сборки
sudo apt-get install -y build-essential cmake ninja-build git python3 perl make gcc pkg-config
echo "--------------------------------------"    
echo "Установка пакетов для Qt Core и базовых модулей!"
echo "--------------------------------------"    
# Зависимости для Qt Core и базовых модулей
sudo apt-get install -y \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxcb-xinput-dev \
    libxcb-keysyms1-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libx11-dev \
    libx11-xcb-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libxrender-dev \
    libxi-dev \
    libinput-dev \
    libxcb-glx0-dev \
    libxcb-icccm4-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-util-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-shape0-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb-cursor-dev \
    libxcursor-dev \
    libxcb-damage0-dev \
    libxcb-xtest0-dev \
    libxcb-res0-dev \
    libxcb-ewmh-dev \
    libxcb-composite0-dev \
    libssl-dev \
    libzstd-dev \
    zlib1g-dev \
    libsqlite3-dev \
    libdbus-1-dev
    


echo "--------------------------------------"    
echo "Включить дополнительные зависимости!"    
echo "--------------------------------------"    
# Включить дополнительные зависимости
sudo apt-get install -y \
    libboost-all-dev \
    libudev-dev \
    libmtdev-dev \
    gstreamer1.0-omx \
    libvpx-dev \
    libsrtp2-dev \
    libsnappy-dev \
    "^libxcb.*" \
    libxslt-dev \
    ruby \
    libbz2-dev \
    libcups2-dev \
    libatkmm-1.6-dev \
    libxi6 \
    libxcomposite1 \
    freetds-dev \
    libpq-dev \
    libiodbc2-dev \
    firebird-dev \
    libxcb1 \
    libxcb1-dev \
    libx11-xcb1 \
    libxcb-shm0 \
    libxcb-icccm4 \
    libxcb-sync1 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    libxss-dev \
    libcap-dev \              
    libdirectfb-dev \
    libaudio-dev \
    gdbserver \
    freeglut3-dev \
    gawk \
    texinfo \
    file \
    wget \
    gdb-multiarch \
    
    


echo "--------------------------------------"    
echo "Установка Clang"    
echo "--------------------------------------"    
sudo apt-get install -y clang libclang-dev

echo "--------------------------------------"    
echo "Установка Nodejs!"
echo "--------------------------------------"    
# Установка Nodejs
sudo apt-get install -y curl
curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt-get install -y nodejs

echo "--------------------------------------"    
echo "Установка пакетов для Qt Multimedia!"
echo "--------------------------------------"    
# Зависимости для Qt Multimedia
#sudo apt purge '^libgstreamer.*' '^gstreamer.*' '^libgst.*' '^gir1.2-gst.*'
#sudo apt autoremove --purge
#sudo apt clean
#sudo rm -rf /var/lib/apt/lists/*
#sudo apt update
sudo apt-get install -y \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    libpulse-dev \
    libalsa-ocaml-dev \
    libasound2-dev
    
#echo "--------------------------------------"    
#echo "Установка графических драйверов (Mali-G610)!"
#echo "--------------------------------------"    
# Установка графических драйверов (Mali-G610)
#sudo apt-get install -y \
#    mesa-utils \
#    mesa-vulkan-drivers
    
echo "--------------------------------------"    
echo "Установка пакетов для поддержки Wayland!"
echo "--------------------------------------"    
# Зависимости для поддержки Wayland
sudo apt-get install -y \
    libwayland-dev \
    libwayland-egl-backend-dev \
    wayland-protocols \
    libwayland-egl1 \
    libwayland-client0 \
    libwayland-server0 \
    
echo "--------------------------------------"    
echo "Установка пакетов для поддержки QtPositioning!"
echo "--------------------------------------"    
# Зависимости для поддержки QtPositioning
sudo apt-get install -y libgeoclue-2-dev        # Для GeoClue (Linux)
sudo apt-get install -y libproxy-dev               # Для работы с прокси

echo "--------------------------------------"    
echo "Установка пакетов для поддержки VA-API (аппаратное ускорение видео)!"
echo "--------------------------------------"    
# Зависимости для поддержки VA-API (аппаратное ускорение видео)
sudo apt-get install -y \
    libva-dev \
    libva-drm2 \
    libva-x11-2
    
echo "--------------------------------------"    
echo "Установка пакетов для поддержки FFmpeg!"
echo "--------------------------------------"    
# Зависимости для поддержки FFmpeg
sudo apt-get install -y \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libavutil-dev \
    libavdevice-dev \
    libavfilter-dev \
    libswresample-dev
    
echo "--------------------------------------"    
echo "Установка пакетов для Qt Modbus!"
echo "--------------------------------------"    
# Зависимости для Qt Modbus
sudo apt-get install -y \
    libmodbus-dev
    
echo "--------------------------------------"    
echo "Установка пакетов для Qt WebEngine!"
echo "--------------------------------------"    
# Зависимости для Qt WebEngine    
    
sudo apt-get install -y python3-html5lib
sudo apt-get install -y gperf   
sudo apt-get install -y bison  
sudo apt-get install -y flex 
    
sudo apt-get install -y \
    libnss3-dev \
    libnspr4-dev \
    libdrm-dev \
    libgbm-dev \
    libxcomposite-dev \
    libxrandr-dev \
    libxdamage-dev \
    libxext-dev \
    libxfixes-dev \
    libxkbfile-dev \
    libxshmfence-dev \
    libxtst-dev \
    libpci-dev \
    libevent-dev \
    libopus-dev \
    libwebp-dev \
    libjsoncpp-dev \
    libminizip-dev \
    libre2-dev \
    libsnappy-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libvulkan-dev \
    vulkan-tools \
    vulkan-validationlayers-dev \
    libicu-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libpng-dev \
    libglib2.0-dev \
    libharfbuzz-dev \
    zlib1g-dev  
    
echo "--------------------------------------"     
echo "Установка пакетов для Qt Network!"    
echo "--------------------------------------"    
# Зависимости для Qt Network
sudo apt-get install -y \
    libzstd-dev \
    zlib1g-dev \
    libb2-dev \
    libdouble-conversion-dev \
    libnm-dev \
    libldap2-dev \
    libkrb5-dev 

echo "--------------------------------------"    
echo "Установка пакетов для SensorFW!" 
echo "--------------------------------------"       
# Зависимости для SensorFW


echo "--------------------------------------"    
echo "Установка пакетов для Hunspell!"   
echo "--------------------------------------"     
# Зависимости для Hunspell
sudo apt-get install -y libhunspell-dev hunspell-en-us hunspell-ru  # Английский + русский словари



echo "--------------------------------------"    
echo "Включить поддержку Accessibility Bridge для X11!"    
echo "--------------------------------------"    
# Включить поддержку Accessibility Bridge для X11!
sudo apt-get install -y \
    libatspi2.0-dev \
    libxtst-dev


echo "--------------------------------------"    
echo "Включить OpenGL ES!"  
echo "--------------------------------------"      
# Включить OpenGL ES!
sudo apt-get install -y \
    libgles2-mesa-dev \
    mesa-common-dev \
    libgl1-mesa-glx \
    libegl1-mesa-dev


echo "--------------------------------------"    
echo "Включить tslib!"
echo "--------------------------------------"        
# Включить tslib!
sudo apt-get install -y libts-dev


echo "--------------------------------------"    
echo "Включить Session Management (SM)!"   
echo "--------------------------------------"     
# Включить Session Management (SM)!
sudo apt-get install -y libsm-dev



echo "--------------------------------------"    
echo "Включить GTK+!" 
echo "--------------------------------------"       
# Включить GTK+!
sudo apt-get install -y \
    libgtk-3-dev \
    libgtk2.0-dev \
    libgdk-pixbuf2.0-dev \


echo "--------------------------------------"    
echo "Включить PipeWire!"
echo "--------------------------------------"        
# Включить PipeWire!
sudo apt-get install -y \
    libpipewire-0.3-dev \
    libspa-0.2-dev


echo "--------------------------------------"    
echo "Включить BlueZ!"  
echo "--------------------------------------"      
# Включить BlueZ!
sudo apt-get install -y libbluetooth-dev # Основная библиотека BlueZ
sudo apt-get install -y bluez-tools # Дополнительные утилиты


echo "--------------------------------------"    
echo "Включить Linux Kernel Crypto API!"    
echo "--------------------------------------"    
# Включить Linux Kernel Crypto API!
sudo apt-get install -y \
    libkmod-dev                # Для работы с модулями ядра


# Очистка кеша
sudo apt-get autoremove -y
sudo apt-get clean

echo "--------------------------------------"    
echo "Установка пакетов завершена!"
echo "--------------------------------------"    
