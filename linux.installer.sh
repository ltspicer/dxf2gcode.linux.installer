#!/bin/sh

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V1.0 #"
echo "#     for Debian based OS       #"
echo "#     by Daniel Luginbuehl      #"
echo "#          (c) 2022             #"
echo "#################################"
echo ""
echo ""
RED='\033[0;31m'
NC='\033[0m'
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

echo "Path to the dxf2gcode source in your home directory e.g. Downloads/source"
read SRC
HOME="$(getent passwd $USER | awk -F ':' '{print $6}')"
path=${HOME}/$SRC
echo "I work in the directory "$path
#echo "Your password is "$PASSWORD
echo "Is that correct (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    exit
fi

sudo apt-get update
sudo apt-get install -y dos2unix
sudo apt-get install -y python3-pip
pip3 install --user pyqt5
sudo apt-get install -y python3-pyqt5  
sudo apt-get install -y pyqt5-dev-tools
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y python-opengl
sudo apt-get install -y qtcreator pyqt5-dev-tools
sudo apt-get install -y poppler-utils
sudo apt-get install -y pstoedit


cd $path
chmod +x make_tr.py
chmod +x make_py_uic.py

dos2unix make_tr.py
./make_tr.py
dos2unix make_py_uic.py
./make_py_uic.py
python3 ./st-setup.py build
sudo python3 ./st-setup.py install

echo "dxf2gcode was successfully installed."
echo "You can start it now with ${RED}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop with command: dxf2gcode %f"
sleep 10



