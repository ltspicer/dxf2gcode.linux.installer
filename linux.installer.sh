#!/bin/bash

echo ""
echo "#################################"
echo "# dxf2gcode Install Script V5.1 #"
echo "#   for Debian & Arch based OS  #"
echo "#      by Daniel Luginbuehl     #"
echo "#   webmaster@ltspiceusers.ch   #"
echo "#          (c) 2026             #"
echo "#################################"
echo ""
echo "Support: https://www.ltspiceusers.ch/#dxf2gcode.68"
echo ""
echo ""

SOURCE_URL=https://sourceforge.net/projects/dxf2gcode/files/dxf2gcode-20220226_RC1.zip/download
DEV_URL=https://sourceforge.net/projects/dxf2gcode/files/Development/dxf2gcode.zip/download
ICON_URL=https://sourceforge.net/projects/dxf2gcode/files/Development/DXF2GCODE.ico/download
sourceforge=true        # Download from github: false | Download from sourceforge: true
pipversion="pip3"       # pip command syntax
pyversion="python3"     # If python-is-python3 is installed, change to "python"
aptversion="apt-get"    # Old style = apt-get | New style = apt

#### Do not make any changes from here!

PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
MAJOR=$(python3 -c "import sys; print(sys.version_info.major)")
MINOR=$(python3 -c "import sys; print(sys.version_info.minor)")
PYDIR="/usr/lib/python${MAJOR}.${MINOR}"

TMPDIR=$(mktemp -d)

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
NC=$'\033[0m'

devinst=0

download_zip() {
    local url="$1"
    local outfile="$2"

    echo "${GREEN}Downloading: $url${NC}"
    wget -O "$outfile" "$url"
    unzip "$outfile" -d "$TMPDIR"
    rm "$outfile"
}

download_source() {
    if $sourceforge ; then
        echo "Download from SOURCEFORGE"
        download_zip "$DEV_URL" "$TMPDIR/dev.zip"
    else
        echo "Download from GITHUB"
        download_zip "https://github.com/ltspicer/dxf2gcode/archive/master.zip" "$TMPDIR/master.zip"
        echo "${GREEN}Downloading icon…${NC}"
        wget -O ${HOME}/DXF2GCODE.ico https://raw.githubusercontent.com/ltspicer/dxf2gcode.linux.installer/main/DXF2GCODE.ico
    fi

    pfad=$(find_deepest_dxf2gcode_dir "$TMPDIR")
    cd "$pfad" || { echo "Error: Could not change to directory $pfad"; exit 1; }

    echo "${GREEN}Current folder: $(pwd)${NC}"
}

find_deepest_dxf2gcode_dir() {
    local current_dir="$1"
    while true; do
        if find "$current_dir" -mindepth 1 -maxdepth 1 -type f | grep -q .; then
            break
        fi
        local next_dir=$(find "$current_dir" -mindepth 1 -maxdepth 1 -type d -name "dxf2gcode*" | head -n 1)
        [ -z "$next_dir" ] && break
        current_dir="$next_dir"
    done
    echo "$current_dir"
}

select_source_dir() {
    echo "If you want automatically download the developer version press y"
    echo "If you want install your own version press n"

    while true; do
        read answer

        # --- Automatic developer download ---
        if echo "$answer" | grep -iq "^y" ; then
            download_source
            devinst=0
            return
        fi

        # --- Manual path selection ---
        if echo "$answer" | grep -iq "^n" ; then
            echo
            echo "${RED}Ok. First download the desired version of dxf2gcode into your home directory${NC} (developer version is needed for Python 3.10+)."
            echo "Download links:"
            echo
            echo "${GREEN}https://sourceforge.net/p/dxf2gcode/sourcecode/ci/develop/tree${NC} (source directory)"
            echo "or"
            echo "${GREEN}https://github.com/ltspicer/dxf2gcode${NC}"
            echo

            while true; do
                echo "Enter path to the dxf2gcode source in your home directory e.g. ${GREEN}Downloads/source ${RED}(without / at the beginning and end!) ${NC}"
                read SRC

                [ -z "$SRC" ] && SRC="_"
                if echo "$SRC" | grep -iq "^q" ; then
                    exit
                fi

                pfad="${HOME}/$SRC"

                echo "${GREEN}I will work in the directory $pfad"
                echo "Is that correct (y/n/q)? (q = Quit installer)${NC}"
                read answer

                if echo "$answer" | grep -iq "^q" ; then
                    exit
                fi

                if echo "$answer" | grep -iq "^y" ; then
                    if [ ! -d "$pfad" ]; then
                        echo "${RED}This directory does not exist!${NC}"
                    else
                        cd "$pfad"
                        devinst=1
                        return
                    fi
                fi
            done
        fi
    done
}

install_debian() {         # PIP error?
    piperror () {
        if [ "$error" -ne "0" ]; then
            echo "${RED}PIP error: $error ${NC}"
            echo
            echo "${RED}To fix the pip error 'externally-managed-environment' do:${NC}"
            echo "${RED}cd $PYDIR${NC}"
            echo "${RED}sudo rm EXTERNALLY-MANAGED${NC}"
            echo
            echo "${RED}See:${NC}"
            echo "${RED}https://www.makeuseof.com/fix-pip-error-externally-managed-environment-linux/${NC}"
            echo
            echo "Restart the script after making corrections."
            echo
            echo "Script ends in 8 seconds"
            sleep 8
            exit 1
        fi
    }

    if ! hash $pyversion; then
        echo "${RED}$pyversion is not installed"
        echo "Script ends in 8 seconds${NC}"
        sleep 8
        exit
    fi

    # Python version >= 3.7 ?
    REQUIRED=3.7

    if [ "$MAJOR" -lt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -lt 7 ]; }; then
        echo "Python $REQUIRED or higher required (found $PYVER)"
        sleep 8
        exit 1
    fi

    $pipversion -V >/dev/null 2>&1
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo
        echo "${GREEN}pip is not installed!"
        echo
        echo "Should I install pip (y/N)?${NC}"
        read answer
        if echo "$answer" | grep -iq "^y" ;then
            sudo $aptversion install -y python3-pip
        else
            echo "Install with:"
            echo "Debian/Ubuntu/Mint:    sudo $aptversion install python3-pip"
            echo
            echo "Non-relevant operating systems:"
            echo "CentOS/Red Hat/Fedora: sudo dnf install --assumeyes python3-pip"
            echo "MacOS:                 sudo easy_install pip"
            echo "Windows:               https://www.geeksforgeeks.org/how-to-install-pip-on-windows/"
            echo
            echo "Script ends in 8 seconds"
            sleep 8
            exit
        fi
    fi

    echo "${GREEN}Installed Python version:"
    $pyversion -V
    echo "${NC}"

    # Must be developer version if Python >= 3.10

    if [ "$MAJOR" -gt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 10 ]; }; then
        echo "${GREEN}Python $PYVER detected (>= 3.10)."
        echo "Developer version of dxf2gcode will be installed.${NC}"
        devinst=1
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

    if echo "$answer" | grep -iq "^1" ; then
        download_zip "$SOURCE_URL" "$TMPDIR/dxf.zip"
        pfad=$(find_deepest_dxf2gcode_dir "$TMPDIR")
        cd "$pfad"

    else
        select_source_dir
    fi

    echo ""
    echo "${GREEN}I will now install. Are you ready (y/n)?${NC}"
    while true; do
        read answer
        if echo "$answer" | grep -iq "^y" ;then
            echo ""
            break
        fi
        if echo "$answer" | grep -iq "^n" ;then
            sudo rm -rf $TMPDIR
            exit
        fi
    done

    #### Install dependencies

    sudo $aptversion update
    echo "Remove orphaned packages:"
    sudo $aptversion autoremove -y
    sudo $aptversion install -y dos2unix
    sudo $aptversion install -y python3-pip
    sudo $aptversion install -y python3-pyqt5
    sudo $aptversion install -y pyqt5-dev-tools
    sudo $aptversion install -y qttools5-dev-tools
    sudo $aptversion install -y python3-opengl
    sudo $aptversion install -y qtcreator pyqt5-dev-tools
    sudo $aptversion install -y poppler-utils
    sudo $aptversion install -y pstoedit

    set +e

    echo "Backup EXTERNALLY-MANAGED"
 
    if [ -f "$PYDIR/EXTERNALLY-MANAGED" ]; then
        sudo mv "$PYDIR/EXTERNALLY-MANAGED" "$PYDIR/EXTERNALLY-MANAGED.bak"
    fi

    echo "**** pip3 install --user PyQt5"
    $pipversion install --user pyqt5
    retVal=$?
    if [ $retVal -ne 0 ]; then
        echo "**** I try: pip3 install --user PyQt5==5.12.2"
        $pipversion install --user PyQt5==5.12.2
        retVal=$?
        if [ $retVal -ne 0 ]; then
            echo "**** I try $aptversion install python3-pyqt5."
            echo "**** Maybe you have to restart the script after 'sudo pip3 install setuptools==65 --break-system-packages' command!"
            set -e
            sudo $aptversion install -y python3-pyqt5
        fi
    fi

    #### If setuptools version > 65.0.0 then set to 65.0.0
    version=$($pipversion show setuptools | grep Version | sed 's/.*: //' | sed 's/\.//g')
    set +e

    # Python >= 3.12 → Setuptools upgrade
    if [ "$MAJOR" -gt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 12 ]; }; then
        echo "${GREEN}**** Python ${MAJOR}.${MINOR} detected (>= 3.12). Setuptools will be upgraded.${NC}"
        $pipversion install --user --upgrade setuptools
        error=$?
        piperror
        echo "${GREEN}**** Setuptools has been upgraded.${NC}"

    # Python < 3.12 → Setuptools downgrade
    else
        echo "${GREEN}**** Python ${MAJOR}.${MINOR} detected (< 3.12). Setuptools will be downgraded to 65.0.0.${NC}"
        $pipversion install --user "setuptools==65.0.0"
        error=$?
        piperror
        echo "${GREEN}**** Setuptools has been downgraded to 65.0.0.${NC}"
    fi

    if [ -f "$PYDIR/EXTERNALLY-MANAGED.bak" ]; then
        echo "Restoring EXTERNALLY-MANAGED for Python ${MAJOR}.${MINOR}"
        sudo mv "$PYDIR/EXTERNALLY-MANAGED.bak" "$PYDIR/EXTERNALLY-MANAGED"
    fi

    set -e

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
    sudo cp $pfad/i18n/*.qm /usr/share/dxf2gcode/i18n
    sudo chmod -R o+r /usr/share/dxf2gcode/i18n
}

install_arch() {

    # Possible paths
    CANDIDATES=(
        "/usr/local/lib/python${PYVER}/site-packages"
        "/usr/lib/python${PYVER}/site-packages"
        "/usr/local/lib/python${PYVER}/dist-packages"
        "/usr/lib/python${PYVER}/dist-packages"
    )

    SITEPKG=""

    # Select the first existing path
    for pkg in "${CANDIDATES[@]}"; do
        if [ -d "$pkg" ]; then
            SITEPKG="$pkg"
            break
        fi
    done

    # If none exists → Error
    if [ -z "$SITEPKG" ]; then
        echo "ERROR: No valid site-packages directory for Python ${PYVER} found."
        exit 1
    fi

    TARGET="$SITEPKG/dxf2gcode"

    # Dependencies
    echo "Install the required packages..."
    sudo pacman -S --needed --noconfirm \
        python-setuptools \
        python-pyqt5 \
        python-opengl \
        qt5-tools \
        poppler \
        pstoedit \
        unzip \
        wget \
        dos2unix \
        python-configobj

    echo "tmpdir: $TMPDIR"

    select_source_dir

    if [ -z "$pfad" ] || [ ! -d "$pfad" ]; then
        echo "${RED}Error: Source directory not found!${NC}"
        exit 1
    fi

    cd "$pfad"

    chmod +x make_tr.py
    chmod +x make_py_uic.py

    dos2unix make_tr.py
    ./make_tr.py
    dos2unix make_py_uic.py
    ./make_py_uic.py

    echo "Patch Build-System for Python ${PYVER} ..."

    # Remove distutils-imports
    sed -i 's/import distutils.command.install_scripts//g' st-setup.py
    sed -i 's/from distutils.core import setup/from setuptools import setup/g' st-setup.py

    # Remove complete install_scripts Class + Method
    sed -i '/class install_scripts/,/^$/d' st-setup.py

    # Remove cmdclass-line
    sed -i '/cmdclass/d' st-setup.py

    echo "Build dxf2gcode..."
    python3 st-setup.py build

    echo "Install dxf2gcode permanently to $TARGET ..."
    sudo rm -rf "$TARGET"
    sudo mkdir -p "$TARGET"
    sudo cp -r "$pfad"/* "$TARGET"
    sudo chmod -R a+r "$TARGET"
    sudo find "$TARGET" -type d -exec chmod a+rx {} \;
    echo "Create launcher /usr/local/bin/dxf2gcode ..."
    sudo tee /usr/local/bin/dxf2gcode >/dev/null << EOF
#!/bin/bash
python3 "$TARGET/dxf2gcode.py" "\$@"
EOF
    sudo chmod +x /usr/local/bin/dxf2gcode
}

install_other() {
    echo "Unsupported OS. Manual installation required."
    exit 1
}

# --- OS detection ---
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/arch-release ]; then
    OS="arch"
else
    OS="other"
fi

case "$OS" in
    debian)
        install_debian
        ;;
    arch)
        install_arch
        ;;
    other)
        install_other
        ;;
esac

ICON_FILE="$HOME/DXF2GCODE.ico"

if [ ! -f "$ICON_FILE" ]; then
    echo "${GREEN}Downloading icon…${NC}"
    wget -O "$ICON_FILE" "$ICON_URL"
fi

if [ $devinst -eq 1 ] ;then
    echo
    echo "Should I delete the "$pfad" directory (y/N)?"
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        sudo rm -rf $pfad
    fi
fi

echo
echo "${RED}dxf2gcode was successfully installed.${NC}"
echo
echo "You can start it now with ${GREEN}dxf2gcode${NC} in the console."
echo "If you want, you can create a starter on the desktop. Use command ${GREEN}dxf2gcode %f${NC} inside the starter."
echo "The icon for the starter is stored at: ${GREEN}"${HOME}/DXF2GCODE.ico"${NC}"

exit 0
