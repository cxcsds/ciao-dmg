#!/bin/bash


TMPDIR=foo
PATCH_DIR=/Users/kjg/Temp/DMG/ciao-dmg/CIAO_DMG
VER=4.17
OS=`uname -m`

BACKGROUND=${PATCH_DIR}/install_w_readme.png
DS_STORE=${PATCH_DIR}/ciao-hack-DS_Store
README=${PATCH_DIR}/ciao-hack-README.txt

# Create conda environment in /Applications folder

conda create -p /Applications/ciao-${VER} \
  --copy --yes \
  -c https://cxc.cfa.harvard.edu/conda/ciao -c conda-forge \
  ciao pyciao ciao-contrib sherpa ds9 marx caldb 

# Move it to temp dir and patch in files

mkdir -p ${TMPDIR}
mv /Applications/ciao-${VER} ${TMPDIR}/

mkdir ${TMPDIR}/.background
cp ${BACKGROUND} ${TMPDIR}/.background

cp ${README} ${TMPDIR}/README.txt

ln -s /Applications ${TMPDIR}/

# --------------------
# Add in setup scripts

sed "s/@VER@/${VER}/" ${PATCH_DIR}/ciao.sh > ${TMPDIR}/ciao-${VER}/bin/ciao.sh
sed "s/@VER@/${VER}/" ${PATCH_DIR}/ciao.csh > ${TMPDIR}/ciao-${VER}/bin/ciao.csh

# -------------------

# Create initial disk image, RW so we can add .DS_Store
# TODO -- estimate size on fly, need to add extra for .DS_Store
/bin/rm -f tmp_ciao-${VER}.0.dmg 
hdiutil create -size 19.1Gb -format UDRW -fs HFS+J \
   -volname "CIAO ${VER}.0"  -srcfolder ${TMPDIR} tmp_ciao-${VER}.0.dmg 
   
# Add .DS_Store
hdiutil attach -readwrite tmp_ciao-${VER}.0.dmg
(cd "/Volumes/CIAO ${VER}.0"; cp -fv ${DS_STORE} .DS_Store)
hdiutil detach "/Volumes/CIAO ${VER}.0"

# Create final compressed, read-only image
rm ciao-${VER}.0-${OS}.dmg
hdiutil convert tmp_ciao-${VER}.0.dmg -format UDZO -o ciao-${VER}.0-${OS}.dmg

rm tmp_ciao-${VER}.0.dmg
