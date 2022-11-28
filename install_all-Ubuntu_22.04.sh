#!/usr/bin/bash

echo "[+] Retrieving submodules"
git submodule update --init --recursive

echo "[+] Installing Python3 requirements"
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install -r requirements.txt

echo "[+] Installing GNU Radio dependencies"
sudo add-apt-repository ppa:gnuradio/gnuradio-releases
sudo apt-get update
gnuradioversion=$(sudo apt policy gnuradio|egrep -i "3.10(.*)"|sed 's/ 500//'|sed 's/     //')
sudo apt-get install gnuradio=$gnuradioversion # forcing GNU Radio 3.8 installation

sudo apt install git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy \
python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 \
liblog4cpp5-dev libzmq3-dev python3-yaml python3-click python3-click-plugins \
python3-zmq python3-scipy python3-gi python3-gi-cairo gobject-introspection gir1.2-gtk-3.0

echo "[+] Installing gr-osmosdr package"
sudo apt install gr-osmosdr

echo "[+] Downloading gr-gsm for Python3 and GNU Radio 3.10"
mkdir thirdparty
cd thirdparty
REMPATH=`pwd`
git clone https://github.com/bkerler/gr-gsm
echo "[+] Building and installing gr-gsm for GNU Radio 3.10"
cd gr-gsm
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ../
make -j$(nproc)
sudo make install
cd ../../
echo "[+] Installing SDK tools"
sudo apt install openjdk-17-jdk
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip
sudo mkdir -p /opt/Android
cd tools
./bin/sdkmanager --sdk_root=/opt/Android --update
sudo ./bin/sdkmanager --sdk_root=/opt/Android --install platform-tools
echo "[+] Installing dependencies for srsLTE"
sudo apt-get install cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev
sudo apt install libsoapysdr-dev
#osmo sdr support:
sudo apt-get install osmo-sdr soapysdr-module-osmosdr
#rtl sdr support:
sudo apt-get install rtl-sdr soapysdr-module-rtlsdr
#blade rf support:
sudo apt-get install bladerf soapysdr-module-bladerf
#hack rf support:
sudo apt-get install hackrf soapysdr-module-hackrf
#usrp support:
sudo apt-get install uhd-host uhd-soapysdr soapysdr-module-uhd
#miri SDR support:
sudo apt-get install miri-sdr soapysdr-module-mirisdr
#rf space support:
sudo apt-get install soapysdr-module-rfspace
#airspy support:
sudo apt-get install airspy soapysdr-module-airspy
echo "[+] Installaing srsLTE for Modmobmap"
cd $REMPATH
cd srsLTE
mkdir build
cd build
cmake ../
make -j$(nproc)
echo "====END===="