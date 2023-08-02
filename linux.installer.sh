#!/bin/sh

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V3.1 #"
echo "#     for Debian based OS       #"
echo "#     by Daniel Luginbuehl      #"
echo "#   webmaster@ltspiceusers.ch   #"
echo "#          (c) 2023             #"
echo "#################################"
echo ""
echo "Support: https://www.ltspiceusers.ch/#dxf2gcode.68"
echo ""
echo ""

source_url=https://sourceforge.net/projects/dxf2gcode/files/dxf2gcode-20220226_RC1.zip/download
source_dev_url=https://sourceforge.net/projects/dxf2gcode/files/Development/dxf2gcode.zip/download
source_icon_url=https://sourceforge.net/projects/dxf2gcode/files/Development/DXF2GCODE.ico/download
sourceforge=true        # Download from github: false | Download from sourceforge: true
pipversion="pip3"       # pip command syntax
pyversion="python3"     # If python-is-python3 is installed, change to "python"
aptversion="apt-get"    # Old style = apt-get | New style = apt

#### Do not make any changes from here!
RED='\033[0;31m'
NC='\033[0m'
devinst=0
HOME="$(getent passwd $USER | awk -F ':' '{print $6}')"

if ! hash $pyversion; then
    echo "$pyversion is not installed"
    echo "Script ends in 8 seconds"
    sleep 8
    exit
fi

echo "Installed Python version:"
$pyversion -V
echo ""

ver=$($pyversion -V | sed 's/.* 3.//' | sed 's/\.[[:digit:]]\+//')

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

pip -V
retVal=$?
if [ $retVal -ne 0 ]; then
    echo
    echo "python3-pip is not installed!"
    echo
    echo "Debian/Ubuntu/Mint:    sudo apt install python3-pip"
    echo "CentOS/Red Hat/Fedora: sudo dnf install --assumeyes python3-pip"
    echo "MacOS:                 sudo easy_install pip"
    echo "Windows:               https://www.geeksforgeeks.org/how-to-install-pip-on-windows/"
    echo
    echo "Window closes in 20 seconds."
    echo "Script ends in 8 seconds"
    sleep 8
    exit
fi

set -e

echo "Do you want install..."
if [ $devinst -eq 0 ] ;then
    echo "1   ...the latest stable version"
    echo "2   ...a developer version"
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
    echo "2   ...a developer version"
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
	echo "Do you want automatically download the developer version? (y) ::: If you do want install your own version press n"

    while true; do
	    read answer
        if echo "$answer" | grep -iq "^y" ;then
            if [ -d /tmp/dxf2gcode-latest ]; then
              sudo rm -rf /tmp/dxf2gcode-latest
            fi
            mkdir /tmp/dxf2gcode-latest

####    Download from sourceforge
            if $sourceforge ; then
                echo "Download from SOURCEFORGE"
                wget -O /tmp/dxf2gcode-latest/dxf2gcode-latest.zip ${source_dev_url}
                unzip /tmp/dxf2gcode-latest/dxf2gcode-latest.zip -d /tmp/dxf2gcode-latest/
                path=/tmp/dxf2gcode-latest/source
                wget -O ${HOME}/DXF2GCODE.ico ${source_icon_url}
            else
####    Download from github
                echo "Download from GITHUB"
                wget -O /tmp/dxf2gcode-latest/master.zip https://github.com/ltspicer/dxf2gcode/archive/master.zip
                unzip /tmp/dxf2gcode-latest/master.zip -d /tmp/dxf2gcode-latest/
                path=/tmp/dxf2gcode-latest/dxf2gcode-main
                wget -O ${HOME}/DXF2GCODE.ico https://raw.githubusercontent.com/ltspicer/dxf2gcode.linux.installer/main/DXF2GCODE.ico
            fi

            cd $path
            devinst=0
            break
        fi
        if echo "$answer" | grep -iq "^n" ;then
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
                path=${HOME}/$SRC
                echo "I will work in the directory "$path
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
            break
        fi
    done
fi

echo ""
echo "I will now install. Are you ready (y/n)?"
while true; do
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        echo ""
        break
    fi
    if echo "$answer" | grep -iq "^n" ;then
        exit
    fi
done

sudo $aptversion update
sudo $aptversion install -y dos2unix
sudo $aptversion install -y $pyversion-pip
sudo $aptversion install -y $pyversion-pyqt5  
sudo $aptversion install -y pyqt5-dev-tools
sudo $aptversion install -y qttools5-dev-tools
sudo $aptversion install -y $pyversion-opengl
sudo $aptversion install -y qtcreator pyqt5-dev-tools
sudo $aptversion install -y poppler-utils
sudo $aptversion install -y pstoedit

set +e

echo "**** pip3 install --user PyQt5"
$pipversion install --user pyqt5
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "**** I try: pip3 install --user PyQt5==5.12.2"
    $pipversion install --user PyQt5==5.12.2
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "**** I try $aptversion install $pyversion-pyqt5."
        echo "${RED}**** Maybe you have to restart the script after 'sudo pip3 install setuptools==65 --break-system-packages' command!${NC}"
        set -e
        sudo $aptversion install $pyversion-pyqt5
    fi    
fi

# If setuptools version > 65.0.0 then set to 65.0.0
ver=$($pipversion show setuptools | grep Version | sed 's/.*: //' | sed 's/\.//g')
set -e
if [ "$ver" -gt "6500" ] ; then
    echo "${RED}**** Setuptools will be downgraded to 65.0.0.${NC}"
    ver=$($pipversion show setuptools | grep Version)
    echo "${RED}**** Current $ver${NC}"
    sudo $pipversion install setuptools==65 --break-system-packages
    echo "${RED}**** Setuptools has been downgraded to 65.0.0.${NC}"
fi

chmod +x make_tr.py
chmod +x make_py_uic.py

dos2unix make_tr.py
./make_tr.py
dos2unix make_py_uic.py
./make_py_uic.py
$pyversion ./st-setup.py build
sudo $pyversion ./st-setup.py install

cd /usr/share
sudo mkdir -p dxf2gcode
cd dxf2gcode
sudo mkdir -p i18n
sudo cp $path/i18n/*.qm /usr/share/dxf2gcode/i18n
sudo chmod -R o+r /usr/share/dxf2gcode/i18n
sudo $aptversion autoremove

echo ""
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo ""
echo "You can start it now with ${RED}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop. Use command ${RED}dxf2gcode %f${NC} inside the starter."
echo "The icon for the starter is stored at: ${RED}"${HOME}/DXF2GCODE.ico"${NC}"

if [ $devinst -eq 1 ] ;then
    echo "Should I delete the "$path" directory (y/n)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        sudo rm -rf $path
    fi
else
    sudo rm -rf /tmp/dxf2gcode-latest
fi
