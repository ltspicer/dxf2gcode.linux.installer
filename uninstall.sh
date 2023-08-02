#!/bin/sh

echo ""
echo "###################################"
echo "# dxf2gcode uninstall Script V1.0 #"
echo "#      for Debian based OS        #"
echo "#      by Daniel Luginbuehl       #"
echo "#    webmaster@ltspiceusers.ch    #"
echo "#           (c) 2023              #"
echo "###################################"
echo ""
echo "Support: https://www.ltspiceusers.ch/#dxf2gcode.68"
echo ""
echo ""

aptversion="apt-get"    # Old style = apt-get | New style = apt

echo "y=yes, n=no, q=quit"
echo "Do you also want to remove the dependencies (y/n/q)?"
while true; do
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        sudo $aptversion purge -y dos2unix
#        sudo $aptversion purge -y pip-pip
#        sudo $aptversion purge -y pip-pyqt5
        sudo $aptversion purge -y pyqt5-dev-tools
        sudo $aptversion purge -y qttools5-dev-tools
#        sudo $aptversion purge -y pip-opengl
        sudo $aptversion purge -y qtcreator pyqt5-dev-tools
        sudo $aptversion purge -y poppler-utils
        sudo $aptversion purge -y pstoedit
        break
    fi
    if echo "$answer" | grep -iq "^n" ;then
        break
    fi
    if echo "$answer" | grep -iq "^q" ;then
        exit
    fi
done

echo "I will now uninstall dxf2gcode (y/q)?"
while true; do
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        echo ""
        break
    fi
    if echo "$answer" | grep -iq "^q" ;then
        exit
    fi
done

sudo rm -rf /usr/share/dxf2gcode
sudo rm -f /usr/local/bin/dxf2gcode
sudo rm -rf ~/.config/dxf2gcode
sudo rm -f /usr/local/lib/python3.7/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.8/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.9/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.10/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.11/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.12/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.13/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.14/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.15/dist-packages/dxf2gcode*
sudo rm -f /usr/local/lib/python3.16/dist-packages/dxf2gcode*

echo
echo "dxf2gcode is now removed!"
