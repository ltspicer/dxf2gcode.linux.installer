#################################
# dxf2gcode Install Script V2.3 #
#     for Debian based OS       #
#     by Daniel Luginbuehl      #
#          (c) 2023             #
#################################

Just start in the console with:
./linux.installer.sh
or double-click and select "run in terminal". Do not start with sudo in front!
Then follow the instructions. The script will install all necessary packages and dxf2gcode automatically.

Python 3.7 or higher is required. This is checked by the script.
The script is tested on Debian 10 & 11 with GNOME, Linux Mint 20.3, 21 Cinnamon, 21.1 MATE, Xubuntu 22.04 (XFCE), Kubuntu 22.04 (KDE) and Lubuntu 20.04.4 (LXDE)

The installation is ONLY complete when the script "dxf2gcode was successfully installed." spends in red!

Let me know if something doesn't work.

Support: https://www.ltspiceusers.ch/#dxf2gcode.68

Download dxf2gcode: https://sourceforge.net/projects/dxf2gcode/files/latest/download

Unfortunately is the installation of Python3.7.3 or higher on Debian 9 (Wheezy) almost impossible.
Many LinuxCNC computers have Debian Wheezy :(

Because official dxf2gcode does not run properly under Python 3.10, the script ask now to install Python 3.9 (Python 3.10 remains installed)
or use the developer version of dxf2gcode.


See https://github.com/ltspicer/dxf2gcode
There is a edited dxf2gcode version which runs on Python 3.10.
The script can download and install this automatically.


Please test it and give me feedback ;)
