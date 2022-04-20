#!/bin/sh

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V1.4 #"
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

if ! hash python3; then
    echo "python3 is not installed"
    exit
fi
ver=$(python3 -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')
if [ "$ver" -lt "37" ]; then
    echo "This script requires python 3.7 or greater"
    exit
fi

set -e     # Comment for Debian 11
echo "First download dxf2gcode here:"
echo "${RED}https://sourceforge.net/projects/dxf2gcode/files/latest/download${NC}"
echo "and ${RED}unzip${NC}."

echo "Are you ready (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    exit
fi

echo "Enter path to the dxf2gcode source in your home directory e.g. Downloads/source"
read SRC
HOME="$(getent passwd $USER | awk -F ':' '{print $6}')"
path=${HOME}/$SRC
echo "I work in the directory "$path
echo "Is that correct (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    exit
fi

cd $path

sudo apt-get update
sudo apt-get install -y dos2unix
sudo apt-get install -y python3-pip
pip3 install --user pyqt5     # pip3 install --user PyQt5==5.12.2    # for Debian 11
sudo apt-get install -y python3-pyqt5  
sudo apt-get install -y pyqt5-dev-tools
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y python-opengl
sudo apt-get install -y qtcreator pyqt5-dev-tools
sudo apt-get install -y poppler-utils
sudo apt-get install -y pstoedit

chmod +x make_tr.py
chmod +x make_py_uic.py

dos2unix make_tr.py
./make_tr.py
dos2unix make_py_uic.py
./make_py_uic.py
python3 ./st-setup.py build
sudo python3 ./st-setup.py install

cd /usr/share
sudo mkdir -p dxf2gcode
cd dxf2gcode
sudo mkdir -p i18n
sudo cp $path/i18n/*.qm /usr/share/dxf2gcode/i18n

echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "You can start it now with ${RED}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop. Use command ${RED}dxf2gcode %f${NC} inside the starter."

echo "Should I delete the "$path" directory (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    sudo rm -rf $path
else
    exit
fi




