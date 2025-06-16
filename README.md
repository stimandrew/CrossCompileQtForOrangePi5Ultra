# CrossCompileQtForOrangePi5Ultra
Описан процесс настройки кросскомпиляции для одноплатного компьютера Orange Pi 5 Ultra

# Кросс компиляция Qt6.5.5 для OrangePi
На этой странице показаны шаги по компиляции Qt6.5.5 для OrangePi. Надеюсь, эта страница поможет тем, кто застрял в официальном руководстве. Перед началом настоятельно рекомендуется использовать ту же Ubuntu 24.04.5.

На ноутбуке рекомендуется установить Ubuntu 24.04.5 https://releases.ubuntu.com/24.04/

На Orange Pi 5 Ultra рекомендуется установить Ubuntu 24.04.2 https://github.com/Joshua-Riek/ubuntu-rockchip/releases/download/v2.4.0/ubuntu-24.04-preinstalled-desktop-arm64-orangepi-5-max.img.xz

# Подготовьте OrangePi
Подключитесь к Orange Pi 5 Ultra через терминал хост машины по протоколу ssh (используйте свое имя устройства и свой ip адрес, если они отличаются от текущих).
```
ssh -p 22 ab@192.168.0.121
```
Обновите систему.
```
sudo apt update
sudo apt upgrade
sudo reboot
```
Установите зависимости из файла install_packages_target.sh
```
cd ~
wget https://raw.githubusercontent.com/stimandrew/CrossCompileQtForOrangePi5Ultra/main/install_packages_target.sh
chmod +x install_packages_target.sh
sudo ./install_packages_target.sh
```
Создайте папку для установки qt6.
```
sudo mkdir /usr/local/qt6
sudo mkdir /opt/vc
```
Предоставьте полный доступ к папке, используемой для развертывания, из Qt Creator. 
```
sudo chmod 777 /usr/local/bin
```
Запомните версии gcc (13.3.0), ld(2.42) и ldd (2.39). Исходный код той же версии следует загрузить для последующей сборки кросс-компилятора.
```
gcc --version
ld --version
ldd --version
```
![Снимок экрана от 2025-06-09 10-58-06](https://github.com/user-attachments/assets/8c074426-8e31-4038-bbc0-b9408e3698e8)

```
ab@ab-orangepi:~$ gcc --version
ld --version
ldd --version
gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0
Copyright (C) 2023 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

GNU ld (GNU Binutils for Ubuntu) 2.42
Copyright (C) 2024 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) a later version.
This program has absolutely no warranty.
ldd (Ubuntu GLIBC 2.39-0ubuntu8.4) 2.39
Copyright (C) 2024 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Roland McGrath and Ulrich Drepper.

```

Откройте ~/.bashrc в редакторе nano.
```
nano ~/.bashrc
```
Добавьте следующий фрагмент кода в конец файла ~/.bashrc.
```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/
```
Обновите внесенные изменения.
```
source ~/.bashrc
```
Разрешить orangepi использовать sudo rsync без пароля
```
echo "orangepi ALL=(ALL) NOPASSWD: /usr/bin/rsync" | sudo tee -a /etc/sudoers
```

# Подготовьте Хост машину
Обновите систему.
```
sudo apt update
sudo apt upgrade
```
Установите зависимости из файла install_packages_target.sh
```
cd ~
wget https://raw.githubusercontent.com/stimandrew/CrossCompileQtForOrangePi5Ultra/main/install_packages_host.sh
chmod +x install_packages_host.sh
sudo ./install_packages_host.sh
```
## Создайте самый последний CMake из исходного кода
```
cd ~
git clone https://github.com/Kitware/CMake.git
cd CMake
./bootstrap && make -j8&& sudo make install
```
![image](https://github.com/user-attachments/assets/7f4975c1-2169-42c0-b2db-a46436c7e813)

Папка CMake больше не нужна. Вы можете удалить ее.
```
cd ~
sudo rm -r CMake
ls -l
```

## Создайте gcc как кросс-компилятор
Загрузите необходимый исходный код. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
На тот момент, когда я создаю эту страницу, они:
* gcc 13.3.0
* binutils 2.42(ld version)
* glibc 2.39(ldd version)
```
cd ~
mkdir gcc_all && cd gcc_all
wget https://ftpmirror.gnu.org/binutils/binutils-2.42.tar.bz2
tar xf binutils-2.42.tar.bz2
```
```
wget https://ftpmirror.gnu.org/glibc/glibc-2.39.tar.bz2
tar xf glibc-2.39.tar.bz2
```
```
wget https://ftpmirror.gnu.org/gcc/gcc-13.3.0/gcc-13.3.0.tar.gz
git clone --depth=1 https://github.com/raspberrypi/linux
tar xf gcc-13.3.0.tar.gz
```
Загрузить и подготовить все необходимые зависимости, требуемые для сборки GCC
```
cd gcc-13.3.0
contrib/download_prerequisites
```

Создайте папку для установки компилятора.
```
sudo mkdir -p /opt/cross-pi-gcc
sudo chown $USER /opt/cross-pi-gcc
sudo chmod 777 -R /opt/cross-pi-gcc
export PATH=/opt/cross-pi-gcc/bin:$PATH
```
Добавьте следующий фрагмент кода в конец файла ~/.bashrc. Обновите внесенные изменения.
```
echo 'export PATH=/opt/cross-pi-gcc/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```
Скопируйте заголовки ядра в указанную выше папку.
```
cd ~/gcc_all
cd linux
make ARCH=arm64 INSTALL_HDR_PATH=/opt/cross-pi-gcc/aarch64-linux-gnu headers_install
```
Создайте Binutils. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
cd ~/gcc_all
mkdir build-binutils && cd build-binutils
../binutils-2.42/configure --prefix=/opt/cross-pi-gcc --target=aarch64-linux-gnu --with-arch=armv8-a+crc+crypto --with-tune=cortex-a76 --with-fpu=neon-fp-armv8 --disable-multilib --disable-werror
make -j$(nproc)
make install
echo "Шаг №1 - сборка и установка Binutils выполнена успешно!"
```
Редактировать gcc-13.3.0/libsanitizer/asan/asan_linux.cpp. Добавьте следующий фрагмент кода.
```
nano ~/gcc_all/gcc-13.3.0/libsanitizer/asan/asan_linux.cpp
```
```
#ifndef PATH_MAX
#define PATH_MAX 4096
#endif
```

Выполните частичную сборку gcc. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
cd ~/gcc_all
mkdir build-gcc && cd build-gcc
../gcc-13.3.0/configure --prefix=/opt/cross-pi-gcc --target=aarch64-linux-gnu --enable-languages=c,c++ --disable-multilib
make -j8 all-gcc
make install-gcc
echo "Шаг №2 - частичная сборка и установка gcc-13.3.0 выполнена успешно!"
```
Частично постройте Glibc. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
cd ~/gcc_all
mkdir build-glibc && cd build-glibc
../glibc-2.39/configure --prefix=/opt/cross-pi-gcc/aarch64-linux-gnu --build=$MACHTYPE --host=aarch64-linux-gnu --target=aarch64-linux-gnu --with-headers=/opt/cross-pi-gcc/aarch64-linux-gnu/include --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j8 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o /opt/cross-pi-gcc/aarch64-linux-gnu/lib
aarch64-linux-gnu-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o /opt/cross-pi-gcc/aarch64-linux-gnu/lib/libc.so
touch /opt/cross-pi-gcc/aarch64-linux-gnu/include/gnu/stubs.h
echo "Шаг №3 - частичная сборка и установка glibc-2.39 выполнена успешно!"
```
Вернемся к gcc.
```
cd ~/gcc_all/build-gcc
make -j8 all-target-libgcc
make install-target-libgcc
echo "Шаг №4 - возврат к gcc выполнен успешно!"
```
Достраивайте glibc.
```
cd ~/gcc_all/build-glibc
make -j8
make install
echo "Шаг №5 - досборка к glibc выполнена успешно!"
```
Завершите строительство gcc.
```
cd ~/gcc_all/build-gcc
make -j8
make install
echo "Шаг №6 - Завершение строительства gcc выполнено успешно!"
```
На данный момент у нас есть полный набор инструментов для кросс-компиляции с gcc. Папка gcc_all больше не нужна. Вы можете удалить ее.
```
cd ~
rm -rf gcc_all
```

## Сборка Qt6
Создайте папки для sysroot и qt6.
```
cd ~
mkdir rpi-sysroot rpi-sysroot/usr rpi-sysroot/opt
mkdir qt6 qt6/host qt6/pi qt6/host-build qt6/pi-build qt6/src
```
Скачайте Qt 6.5.5 из официального репозитория

Разархивируйте исходный код Qt
```
cd ~/qt6/src
tar xf ~/Загрузки/qt-everywhere-src-6.5.5.tar.xz
```
### Сборка Qt6 для Хост машины
```
cd $HOME/qt6/host-build/
cmake ../src/qt-everywhere-src-6.5.5/ -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DBUILD_qtwebengine=OFF  -DCMAKE_INSTALL_PREFIX=$HOME/qt6/host
```
```
cmake --build . --parallel 8
```
```
cmake --install .
```
Двоичные файлы будут находиться в $HOME/qt6/host
### Сборка Qt6 для OrangePi
скопируйте и вставьте несколько папок из OrangePi с помощью rsync через SSH. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
cd ~
rsync -avz --rsync-path="sudo rsync" ab@192.168.0.121:/usr/include rpi-sysroot/usr
rsync -avz --rsync-path="sudo rsync" ab@192.168.0.121:/lib rpi-sysroot
rsync -avz --rsync-path="sudo rsync" ab@192.168.0.121:/usr/lib rpi-sysroot/usr 
rsync -avz --rsync-path="sudo rsync" ab@192.168.0.121:/opt/vc rpi-sysroot/opt
```
Создайте файл с именем toolchain.cmake в файле $HOME/qt6.
```
cd ~/qt6
wget https://raw.githubusercontent.com/stimandrew/CrossCompileQtForOrangePi5Ultra/main/toolchain.cmake
```
Исправьте абсолютные символические ссылки
```
cd ~
wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
chmod +x sysroot-relativelinks.py 
python3 sysroot-relativelinks.py rpi-sysroot
```
Скомпилируйте исходный код для rpi.
```
cd $HOME/qt6/pi-build
cmake ../src/qt-everywhere-src-6.5.5/ -GNinja -DCMAKE_BUILD_TYPE=Release -DQT_FEATURE_opengles2=ON -DQT_FEATURE_opengles3=ON -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DQT_HOST_PATH=$HOME/qt6/host -DCMAKE_STAGING_PREFIX=$HOME/qt6/pi -DCMAKE_INSTALL_PREFIX=/usr/local/qt6 -DCMAKE_TOOLCHAIN_FILE=$HOME/qt6/toolchain.cmake -DQT_QMAKE_TARGET_MKSPEC=linux-aarch64-gnu-g++ -DLLVM_DIR=/usr/lib/llvm-18/lib/cmake/llvm -DClang_DIR=/usr/lib/llvm-18/lib/cmake/clang -DBUILD_qtwebengine=OFF
```
```
cmake --build . --parallel 8
```
```
cmake --install .
```
Отправьте двоичные файлы в rpi. **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
rsync -avz --rsync-path="sudo rsync" $HOME/qt6/pi/* ab@192.168.0.121:/usr/local/qt6
```
## С помощью Qt Creator
Скачайте и установите **Qt Creator 14.0.2** из официального репозитория.
```
cd ~
sudo dpkg -i ~/Загрузки/qtcreator-linux-x64-14.0.2.deb
```
Настройте **Компиляторы**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/e98645c4-cf99-45e3-a8b4-ecc0899d6fa0)

Настройте **Отладчики**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/f75adf17-b8eb-4149-a5fc-cf59978aa3d9)

Настройте **Устройства**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/57609ea4-6901-41a8-8264-c6bb7aeac844)

Click **Deploy Public Key...** to deploy the key. Создайте его, если он еще не существовал.

Протестируйте устройство.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/9883e600-7963-48e3-98fc-dc3f2e651bff)

Настройте **Профили Qt**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/6c43b6f0-a256-4d2d-86f6-80bb393602af)

Настройте **Комплекты**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/93e04b07-7cbc-43d6-a17c-53fe6d272de9)

В **CMake Configuration** opton нажмите "Изменить" и "Добавить следующие команды". **Вам следует изменить следующие команды в соответствии с вашими потребностями.**
```
-DCMAKE_TOOLCHAIN_FILE:UNINITIALIZED=/home/ab/qt6/pi/lib/cmake/Qt6/qt.toolchain.cmake
```
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/d7c4600a-7058-4541-bdfd-ce184e7fd94c)

## Тест HelloWorld
On **Help** option select **About Plugins**.Then uncheck **ClangCodeModel**.

![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/efb1db08-c5cc-4210-adfe-85507e36d329)

Добавьте следующий фрагмент кода в конец раздела CMakeLists.txt.
```
install(TARGETS HelloWorld
    RUNTIME DESTINATION ""
    BUNDLE DESTINATION ""
    LIBRARY DESTINATION ""
)
```
Goto **Projects**
Under **Run** section, on **X11 Forwarding** check **Forward to local display** and input :0 to the text field. 
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/b396954b-fb04-48ae-a3c4-8ae67178513e)

Under **Environment** section, click **Details** to expand the environment option. Click **Add**, then on **Variable** column type **LD_LIBRARY_PATH**. On the **Value** column, type **:/usr/local/qt6/lib/**.
![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/059f275c-bfa4-4357-b4b6-82880b5c1054)

Запуск.

![image](https://github.com/MuyePan/CrossCompileQtForRpi/assets/136073506/ee26ad77-f370-433b-8734-89e70c21903c)

Теперь у нас есть HelloWorld, работающий на RPI.
