**-dxf2gcode Install Script V5.0**<br>
**-   for Debian & Arch based OS**<br>
**-      by Daniel Luginbuehl**<br>
**-   webmaster@ltspiceusers.ch**<br>
**-          (c) 2026**<br>


Enter in the console:

For Debian (e.g. Ubuntu, Mint) & Arch (e.g. CachyOS) based OSes:<br>
**cd ~/Downloads**<br>
**wget https://raw.github.com/ltspicer/dxf2gcode.linux.installer/main/linux.installer.sh**<br>
**chmod a+x linux.installer.sh**<br>
**./linux.installer.sh**<br>

or download the file linux.installer.sh, make it executable ( chmod a+x linux.installer.sh ) and start it with: ./linux.installer.sh<br>

Then follow the instructions. The script will install all necessary packages and dxf2gcode automatically.


Python 3.7 or higher is required. This is checked by the script.

Only for Debian based OS: pip must be installed. Install with: sudo apt-get install python3-pip<br>


The script is tested on:<br>

**Debian** 10, 11 & 12 with GNOME & MATE<br>
**Xubuntu** 22.04 (XFCE), **Kubuntu** 22.04 (KDE) and **Lubuntu** 20.04.4 (LXDE)<br>
**Raspberry OS/Raspbian**, **MX Linux**<br>
**Linux Mint**: 20.3 MATE, 21.x Cinnamon, 21.x MATE, 22.x MATE<br>

**CachyOS** (cachyos-desktop-linux-260426)<br>


The installation is ONLY complete when the script "**dxf2gcode was successfully installed.**" spends in red!<br>

Because official dxf2gcode does not run properly under Python 3.10+, the script ask to install a developer version of dxf2gcode.<br>
If desired, the script can download this automatically.<br>


Developer versions on<br>
https://github.com/ltspicer/dxf2gcode  
or<br>
https://sourceforge.net/projects/dxf2gcode/files/Development/  
The script can download and install this automatically.<br>

Support: https://www.ltspiceusers.ch/#dxf2gcode.68  
Download dxf2gcode: https://sourceforge.net/projects/dxf2gcode/files/latest/download  


Please test it and give me feedback ;)
