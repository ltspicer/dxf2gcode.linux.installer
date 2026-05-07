#!/bin/bash

echo ""
echo "########################################"
echo "#      dxf2gcode Installer V1.0        #"
echo "#          for Arch/CachyOS            #"
echo "#        by D. Luginbuehl 2026         #"
echo "########################################"
echo ""

# URLs
SOURCE_URL="https://sourceforge.net/projects/dxf2gcode/files/dxf2gcode-20220226_RC1.zip/download"
DEV_URL="https://sourceforge.net/projects/dxf2gcode/files/Development/dxf2gcode.zip/download"
ICON_URL="https://sourceforge.net/projects/dxf2gcode/files/Development/DXF2GCODE.ico/download"

# Python version
PYVER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

# Possible paths
CANDIDATES=(
    "/usr/local/lib/python${PYVER}/site-packages"
    "/usr/lib/python${PYVER}/site-packages"
    "/usr/local/lib/python${PYVER}/dist-packages"
    "/usr/lib/python${PYVER}/dist-packages"
)

SITEPKG=""

# Select the first existing path
for path in "${CANDIDATES[@]}"; do
    if [ -d "$path" ]; then
        SITEPKG="$path"
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

# Download stable or dev
#echo "1 = Stable Version"
#echo "2 = Developer Version"
#read -p "Selection: " CHOICE
CHOICE=2 # Select Developer Version

TMPDIR=$(mktemp -d)
echo "tmpdir: $TMPDIR"

if [[ "$CHOICE" == "1" ]]; then
    wget -O "$TMPDIR/dxf.zip" "$SOURCE_URL"
else
    wget -O "$TMPDIR/dxf.zip" "$DEV_URL"
fi

unzip "$TMPDIR/dxf.zip" -d "$TMPDIR"
SRC_DIR=$(find "$TMPDIR" -type d -name "dxf2gcode*" | head -n 1)

cd "$SRC_DIR"

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
sudo cp -r "$SRC_DIR"/* "$TARGET"

echo "Create launcher /usr/local/bin/dxf2gcode ..."

sudo tee /usr/local/bin/dxf2gcode >/dev/null << EOF
#!/bin/bash
python3 "$TARGET/dxf2gcode.py" "\$@"
EOF

sudo chmod +x /usr/local/bin/dxf2gcode

echo "Load Icon..."
wget -O "$HOME/DXF2GCODE.ico" "$ICON_URL"

echo ""
echo "##########################################"
echo "dxf2gcode has been installed successfully."
echo "Start it with: dxf2gcode"
echo "Icon is in: $HOME/DXF2GCODE.ico"
echo "##########################################"

