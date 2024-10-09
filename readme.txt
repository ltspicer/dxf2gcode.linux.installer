#################################
# dxf2gcode Install Script V3.5 #
#     for Debian based OS       #
#     by Daniel Luginbuehl      #
#          (c) 2024             #
#################################


Enter in console:


cd ~/Downloads

wget https://raw.github.com/ltspicer/dxf2gcode.linux.installer/main/linux.installer.sh

chmod a+x linux.installer.sh

./linux.installer.sh



Then follow the instructions. The script will install all necessary packages and dxf2gcode automatically.

Python 3.7 or higher is required. This is checked by the script.
pip must be installed. Install with: sudo apt-get install python3-pip
The script is tested on Debian 10, 11 & 12 with GNOME & MATE, Linux Mint 20.3 mate, 21 Cinnamon, 21.1 MATE, 21.3 MATE, 22 MATE, Xubuntu 22.04 (XFCE), Kubuntu 22.04 (KDE) and Lubuntu 20.04.4 (LXDE)

The installation is ONLY complete when the script "dxf2gcode was successfully installed." spends in red!

Unfortunately is the installation of Python3.7.3 or higher on Debian 9 (Wheezy) almost impossible.
Many LinuxCNC computers have Debian Wheezy :(


Because official dxf2gcode does not run properly under Python 3.10+, the script ask to install a developer version of dxf2gcode.
If desired, the script can download this automatically.


Developer versions on
https://github.com/ltspicer/dxf2gcode
or
https://sourceforge.net/projects/dxf2gcode/files/Development/
The script can download and install this automatically.

Support: https://www.ltspiceusers.ch/#dxf2gcode.68
Download dxf2gcode: https://sourceforge.net/projects/dxf2gcode/files/latest/download


Please test it and give me feedback ;)
