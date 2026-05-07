#!/bin/sh

echo ""
echo "###################################"
echo "# dxf2gcode uninstall Script V3.0 #"
echo "#    for Debian + Arch/CachyOS    #"
echo "#       by Daniel Luginbuehl      #"
echo "#             (C) 2026            #"
echo "###################################"
echo ""

# --- OS Detection ---------------------------------------------------------

if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/arch-release ]; then
    OS="arch"
else
    echo "Unsupported OS. Only Debian/Ubuntu and Arch/CachyOS are supported."
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# --- Ask about dependency removal ----------------------------------------

echo "Remove dependencies as well (y/n/q)?"
while true; do
    read answer
    case "$answer" in
        [Yy]* )
            REMOVE_DEPS=1
            break ;;
        [Nn]* )
            REMOVE_DEPS=0
            break ;;
        [Qq]* )
            exit ;;
    esac
done

# --- Debian dependency removal -------------------------------------------

if [ "$OS" = "debian" ] && [ "$REMOVE_DEPS" = "1" ]; then
    echo "Removing Debian dependencies..."
    sudo apt-get purge -y dos2unix pyqt5-dev-tools qttools5-dev-tools poppler-utils pstoedit
fi

# --- Arch dependency removal ---------------------------------------------

if [ "$OS" = "arch" ] && [ "$REMOVE_DEPS" = "1" ]; then
    echo "Removing Arch/CachyOS dependencies..."
    sudo pacman -Rns --noconfirm \
        dos2unix \
        python-pyqt5 \
        python-opengl \
        qt5-tools \
        poppler-utils \
        pstoedit
fi

# --- Confirm uninstall ----------------------------------------------------

echo ""
echo "Uninstall dxf2gcode now (y/q)?"
while true; do
    read answer
    case "$answer" in
        [Yy]* ) break ;;
        [Qq]* ) exit ;;
    esac
done

# --- Remove launcher + config --------------------------------------------

echo "Removing launcher and config..."
sudo rm -f /usr/local/bin/dxf2gcode
rm -rf ~/.config/dxf2gcode
rm -f "${HOME}/DXF2GCODE.ico"
sudo rm -f /usr/share/icons/DXF2GCODE.ico
rm -f ~/.local/share/icons/dxf2gcode.*

# --- Remove Python modules (dynamic) -------------------------------------

echo "Removing Python modules..."

# Detect installed Python versions
PYVERS=$(ls /usr/lib | grep -E '^python[0-9]+\.[0-9]+$' | sed 's/python//')

for ver in $PYVERS; do
    for base in /usr/lib /usr/local/lib; do
        for pkg in site-packages dist-packages; do
            TARGET="$base/python$ver/$pkg/dxf2gcode"
            if [ -d "$TARGET" ]; then
                echo "Removing $TARGET"
                sudo rm -rf "$TARGET"
            fi
        done
    done
done

echo ""
echo "dxf2gcode has been removed."
echo ""

