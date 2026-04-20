#!/bin/bash

# ==============================================================================
# SCRIPT MULTIPLATAFORMA DE INPARQUES (LINUX & ANDROID)
# ==============================================================================

# Colores para la terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

APP_NAME="inparques"
PKG_NAME="inparques-bailadores"
VERSION="1.0.0"
ARCH="amd64"
MAINTAINER="Cesar <cespereira83@gmail.com>"
DEB_DIR="${PKG_NAME}_${VERSION}_${ARCH}"

echo -e "${YELLOW}Iniciando construcción MULTIPLATAFORMA de INPARQUES Bailadores...${NC}\n"

# 1. Compilar para Android (APK)
echo -e "${YELLOW}[1/6] Compilando APK para Android (Tecno Spark 20)...${NC}"
flutter build apk --release
if [ $? -ne 0 ]; then
    echo -e "${RED}Error compilando Android. Abortando.${NC}"
    exit 1
fi

# 2. Compilar para Linux
echo -e "${YELLOW}[2/6] Compilando aplicación para PC (Linux)...${NC}"
flutter build linux --release
if [ $? -ne 0 ]; then
    echo -e "${RED}Error compilando Linux. Abortando.${NC}"
    exit 1
fi

# 3. Preparar Entregables
echo -e "${YELLOW}[3/6] Creando carpeta de entregables (releases/)...${NC}"
mkdir -p releases
cp build/app/outputs/flutter-apk/app-release.apk "releases/${PKG_NAME}_${VERSION}.apk"

# 4. Crear estructura DEB
echo -e "${YELLOW}[4/6] Creando estructura del paquete Debian...${NC}"
mkdir -p "${DEB_DIR}/DEBIAN"
mkdir -p "${DEB_DIR}/opt/${APP_NAME}"
mkdir -p "${DEB_DIR}/usr/share/applications"

cp -r build/linux/x64/release/bundle/* "${DEB_DIR}/opt/${APP_NAME}/"

# 5. Generar Metadatos DEB
echo -e "${YELLOW}[5/6] Generando metadatos y accesos directos de escritorio...${NC}"
cat <<EOF > "${DEB_DIR}/DEBIAN/control"
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: ${MAINTAINER}
Description: Sistema de Gestion de Guardias y Personal - INPARQUES Bailadores.
 Desarrollado para la oficina de INPARQUES en el Municipio Rivas Davila.
EOF

cat <<EOF > "${DEB_DIR}/usr/share/applications/${APP_NAME}.desktop"
[Desktop Entry]
Name=INPARQUES Bailadores
Comment=Gestion de Personal y Guardias
Exec=/opt/${APP_NAME}/${APP_NAME}
Icon=/opt/${APP_NAME}/data/flutter_assets/assets/images/logo_inparques.png
Terminal=false
Type=Application
Categories=Office;Development;
EOF

# 6. Empaquetar y Limpiar
echo -e "${YELLOW}[6/6] Construyendo archivo .deb final...${NC}"
chmod -R 755 "${DEB_DIR}"
dpkg-deb --build "${DEB_DIR}"
mv "${DEB_DIR}.deb" "releases/"
rm -rf "${DEB_DIR}"

echo -e "\n${GREEN}¡ÉXITO! Se han generado los instaladores en la carpeta 'releases/':${NC}"
echo -e "- ${YELLOW}releases/${PKG_NAME}_${VERSION}.apk${NC} (Para el Tecno Spark y Android)"
echo -e "- ${YELLOW}releases/${DEB_DIR}.deb${NC} (Para PC Xubuntu)"
