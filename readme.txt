#################################
# dxf2gcode Install Script V3.1 #
#     for Debian based OS       #
#     by Daniel Luginbuehl      #
#          (c) 2023             #
#################################

Just start in the console with:
./linux.installer.sh
or double-click and select "run in terminal". Do not start with sudo in front!
In Debian, first type "su - root" and run the script there.
Then follow the instructions. The script will install all necessary packages and dxf2gcode automatically.

Python 3.7 or higher is required. This is checked by the script.
pip must be installed. Install with: sudo apt-get install python3-pip
The script is tested on Debian 10, 11 & 12 with GNOME & MATE, Linux Mint 20.3 mate, 21 Cinnamon, 21.1 MATE, Xubuntu 22.04 (XFCE), Kubuntu 22.04 (KDE) and Lubuntu 20.04.4 (LXDE)

The installation is ONLY complete when the script "dxf2gcode was successfully installed." spends in red!

Unfortunately is the installation of Python3.7.3 or higher on Debian 9 (Wheezy) almost impossible.
Many LinuxCNC computers have Debian Wheezy :(


In some cases, the following error appears:

...
running egg_info
/home/daniel/.local/lib/python3.10/site-packages/setuptools/command/egg_info.py:131: SetuptoolsDeprecationWarning: Invalid version: '2022-05-05'.
!!

        ********************************************************************************
        Version '2022-05-05' is not valid according to PEP 440.

        Please make sure to specify a valid version for your package.
        Also note that future releases of setuptools may halt the build process
        if an invalid version is given.

        By 2023-Sep-26, you need to update your project and remove deprecated calls
        or your builds will no longer be supported.

        See https://peps.python.org/pep-0440/ for details.
        ********************************************************************************

!!
  return _normalization.best_effort_version(tagged)
...

Then you have to downgrade setup tools. Enter in the terminal:

pip install --upgrade --user setuptools==58.3.0
if not work, then
pip install setuptools==65 --break-system-packages

Then run the installer again.


Because official dxf2gcode does not run properly under Python 3.10+, the script ask to install a developer version of dxf2gcode.
If desired, the script can download this automatically.


Developer versions on
https://github.com/ltspicer/dxf2gcode
or
https://sourceforge.net/projects/dxf2gcode/files/Development/

Support: https://www.ltspiceusers.ch/#dxf2gcode.68
Download dxf2gcode: https://sourceforge.net/projects/dxf2gcode/files/latest/download


Please test it and give me feedback ;)
