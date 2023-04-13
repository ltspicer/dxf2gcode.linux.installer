#!/bin/sh

source_url=https://sourceforge.net/projects/dxf2gcode/files/dxf2gcode-20220226_RC1.zip/download
source_dev_url=https://sourceforge.net/projects/dxf2gcode/files/Development/dxf2gcode.zip/download
#source_dev_url=https://sourceforge.net/projects/dxf2gcode/files/Development/DXF2GCODE-2023.2.6-source.zip/download

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V2.6 #"
echo "#     for Debian based OS       #"
echo "#     by Daniel Luginbuehl      #"
echo "#   webmaster@ltspiceusers.ch   #"
echo "#          (c) 2023             #"
echo "#################################"
echo ""
echo "Support: https://www.ltspiceusers.ch/#dxf2gcode.68"
echo ""
echo ""
RED='\033[0;31m'
NC='\033[0m'
pipversion="pip3"
pyversion="python3"
devinst=0

if ! hash python3; then
    echo "python3 is not installed"
    echo "Script ends in 8 seconds"
    sleep 8
    exit
fi

echo "Installed Python version:"
python3 -V
echo ""

ver=$(python3 -V | sed 's/.* 3.//' | sed 's/\.[[:digit:]]\+//')

if [ "$ver" -lt "7" ] || [ -z "$ver" ]; then
    echo "This script requires python 3.7 or higher"
    echo "Script ends in 8 seconds"
    sleep 8
    exit
fi

if [ "$ver" -ge "10" ]; then
    echo "It seems that you are using Python 3.10 or higher."
    echo "In order for dxf2gcode to run properly, the developer version must be installed."
    devinst=1
fi

set -e

echo "Do you want automatically download and install..."
if [ $devinst -eq 0 ] ;then
    echo "1   ...the latest stable version"
    echo "2   ...the developer version"
    echo "3   Quit installer"
    while true; do
	    read answer
        if echo "$answer" | grep -iq "^3" ;then
            exit
        fi
        if echo "$answer" | grep -iq "^1" ;then
            break
        fi
        if echo "$answer" | grep -iq "^2" ;then
            break
        fi
    done
else
    echo "2   ...the developer version"
    echo "3   Quit installer"
    while true; do
	    read answer
        if echo "$answer" | grep -iq "^3" ;then
            exit
        fi
        if echo "$answer" | grep -iq "^2" ;then
            break
        fi
    done

fi

if echo "$answer" | grep -iq "^1" ;then
    if [ -d /tmp/dxf2gcode-latest ]; then
      sudo rm -rf /tmp/dxf2gcode-latest
    fi

    mkdir /tmp/dxf2gcode-latest
    wget -O /tmp/dxf2gcode-latest/dxf2gcode-latest.zip ${source_url}
    unzip /tmp/dxf2gcode-latest/dxf2gcode-latest.zip -d /tmp/dxf2gcode-latest/
    path=/tmp/dxf2gcode-latest/source
    cd $path

else
	echo "Do you want automatically download the developer version (y/n)?"
	read answer
    if echo "$answer" | grep -iq "^y" ;then
        if [ -d /tmp/dxf2gcode-latest ]; then
          sudo rm -rf /tmp/dxf2gcode-latest
        fi
        mkdir /tmp/dxf2gcode-latest

#### Download from sourceforge
        wget -O /tmp/dxf2gcode-latest/dxf2gcode-latest.zip ${source_dev_url}
        unzip /tmp/dxf2gcode-latest/dxf2gcode-latest.zip -d /tmp/dxf2gcode-latest/
        path=/tmp/dxf2gcode-latest/source

#### Download from github
#        wget -O /tmp/dxf2gcode-latest/master.zip https://github.com/ltspicer/dxf2gcode/archive/master.zip
#        unzip /tmp/dxf2gcode-latest/master.zip -d /tmp/dxf2gcode-latest/
#        path=/tmp/dxf2gcode-latest/dxf2gcode-main

        cd $path
        devinst=0
    else
        echo "Ok. First download the desired version of dxf2gcode ${RED}into your home directory${NC} (developer version is needed for Python 3.10+)."
        echo "Download links:"
        echo ""
        echo "${RED}https://sourceforge.net/p/dxf2gcode/sourcecode/ci/develop/tree${NC} (source directory)"
        echo "or"
        echo "${RED}https://github.com/ltspicer/dxf2gcode${NC}"
        echo ""
        while true; do
            echo "Enter path to the dxf2gcode source in your home directory e.g. Downloads/source (without / at the beginning and end!)"
            read SRC
            if [ -z "$SRC" ] ;then
                SRC="_"
            fi
            if echo "$SRC" | grep -iq "^q" ;then
                exit
            fi
            HOME="$(getent passwd $USER | awk -F ':' '{print $6}')"
            path=${HOME}/$SRC
            echo "I work in the directory "$path
            echo "Is that correct (y/n)? (q = Quit installer)"
            read answer
            if echo "$answer" | grep -iq "^q" ;then
                exit
            fi
            if echo "$answer" | grep -iq "^y" ;then
                if [ ! -d $path ]; then
                    echo "This directory does not exist!"
                else
                    cd $path
                    break
                fi
            fi
        done
        devinst=1
    fi
fi

echo ""
echo "I will now install. Are you ready (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    exit
fi

sudo apt-get update
sudo apt-get install -y dos2unix
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-pyqt5  
sudo apt-get install -y pyqt5-dev-tools
sudo apt-get install -y qttools5-dev-tools
sudo apt-get install -y python3-opengl
sudo apt-get install -y qtcreator pyqt5-dev-tools
sudo apt-get install -y poppler-utils
sudo apt-get install -y pstoedit

set +e

#pip3 install --user pyqt5 > PyQt5==5.12.2 for Debian 11
echo "**** pip3 install --user PyQt5"
$pipversion install --user pyqt5
retVal=$?
if [ $retVal -ne 0 ]; then
    set -e
    echo "**** I try: pip3 install --user PyQt5==5.12.2"
    $pipversion install --user PyQt5==5.12.2
fi

chmod +x make_tr.py
chmod +x make_py_uic.py

set -e

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
sudo chmod -R o+r /usr/share/dxf2gcode/i18n

echo ""
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo ""
echo "You can start it now with ${RED}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop. Use command ${RED}dxf2gcode %f${NC} inside the starter."

if [ $devinst -eq 1 ] ;then
    echo "Should I delete the "$path" directory (y/n)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        sudo rm -rf $path
    fi
else
    sudo rm -rf /tmp/dxf2gcode-latest
fi
