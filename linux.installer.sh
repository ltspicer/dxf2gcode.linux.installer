#!/bin/sh

source_url=https://sourceforge.net/projects/dxf2gcode/files/dxf2gcode-20220226_RC1.zip/download

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V1.8 #"
echo "#     for Debian based OS       #"
echo "#     by Daniel Luginbuehl      #"
echo "#          (c) 2022             #"
echo "#################################"
echo ""
echo "Support: https://www.ltspiceusers.ch/#dxf2gcode.68"
echo ""
echo ""
RED='\033[0;31m'
NC='\033[0m'
pipversion="pip3"
pyversion="python3"

if ! hash python3; then
    echo "python3 is not installed"
    exit
fi

echo "Installed Python version:"
python3 -V
echo ""

ver=$(python3 -V | sed 's/.* 3.//' | sed 's/\.[[:digit:]]\+//')

if [ "$ver" -lt "7" ] || [ -z "$ver" ]; then
    echo "This script requires python 3.7 or higher"
    exit
fi

if [ "$ver" -eq "10" ] && ! hash python3.9; then
    echo "dxf2gcode works not properly with Python 3.10!"
    echo "Should I install Python 3.9 (y/n)?"
    echo "(Python 3.10 will remain installed)"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        echo ""
    else
        exit
    fi

    # Install Python 3.9
    sudo apt-get update
    sudo apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y
    cd /tmp

    if [ -d Python-3.9.7 ]; then
      sudo rm -rf Python-3.9.7
    fi
    if [ -f Python-3.9.7.tgz ]; then
      sudo rm Python-3.9.7.tgz
    fi

    wget https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz
    tar -xvf Python-3.9.7.tgz
    cd Python-3.9.7/
    ./configure --enable-optimizations
    make
    sudo make altinstall
    pipversion="pip3.9"
    pyversion="python3.9"
    cd ..
    sudo rm -rf Python-3.9.7
    rm Python-3.9.7.tgz
    if ! hash python3.9; then
        echo "Something didn't work out there. Install Python 3.9 manually."
        echo "https://linuxhint.com/install-python-ubuntu-22-04/"
        exit
    fi
fi


set -e

echo "Do you want automatically download and install the latest stable (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "dxf2gcode will be automatically downloaded and installed"
    echo ""
    echo "${RED}${source_url}${NC}"
    echo ""
    echo "Are you ready (y/n)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        echo ""
    else
        exit
    fi

    if [ -d /tmp/dxf2gcode-latest ]; then
      sudo rm -rf /tmp/dxf2gcode-latest
    fi

    mkdir /tmp/dxf2gcode-latest
    wget -O /tmp/dxf2gcode-latest/dxf2gcode-latest.zip ${source_url}
    unzip /tmp/dxf2gcode-latest/dxf2gcode-latest.zip -d /tmp/dxf2gcode-latest/
    path=/tmp/dxf2gcode-latest/source
    cd $path

else
    echo "First download the desired version of dxf2gcode ${RED}into your home directory${NC}."
    echo "${RED}https://sourceforge.net/p/dxf2gcode/sourcecode/ci/develop/tree${NC} (source directory)"
    echo "Are you ready (y/n)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        echo ""
    else
        exit
    fi

    echo "Enter path to the dxf2gcode source in your home directory e.g. Downloads/source (without / at the beginning and end!)"
    read SRC
    HOME="$(getent passwd $USER | awk -F ':' '{print $6}')"
    path=${HOME}/$SRC
    echo "I work in the directory "$path
    echo "Is that correct (y/n)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        cd $path
    else
        exit
    fi
fi

sudo apt-get update
sudo apt-get install -y dos2unix
sudo apt-get install -y python3-pip

#pip3 install --user pyqt5 > PyQt5==5.12.2 for Debian 11

set +e

echo "**** pip3 install --user PyQt5"
$pipversion install --user pyqt5
retVal=$?
if [ $retVal -ne 0 ]; then
    set -e
    echo "**** I try: pip3 install --user PyQt5==5.12.2"
    $pipversion install --user PyQt5==5.12.2
fi


set -e

sudo apt-get install -y python3-pyqt5  
sudo apt-get install -y pyqt5-dev-tools
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y python3-opengl
sudo apt-get install -y qtcreator pyqt5-dev-tools
sudo apt-get install -y poppler-utils
sudo apt-get install -y pstoedit

chmod +x make_tr.py
chmod +x make_py_uic.py

set +e
dos2unix make_tr.py
./make_tr.py
dos2unix make_py_uic.py
./make_py_uic.py
$pyversion ./st-setup.py build
sudo $pyversion ./st-setup.py install

set -e
cd /usr/share
sudo mkdir -p dxf2gcode
cd dxf2gcode
sudo mkdir -p i18n
sudo cp $path/i18n/*.qm /usr/share/dxf2gcode/i18n

echo ""
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo ""
echo "You can start it now with ${RED}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop. Use command ${RED}dxf2gcode %f${NC} inside the starter."

echo "Should I delete the "$path" directory (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    sudo rm -rf $path
else
    exit
fi
