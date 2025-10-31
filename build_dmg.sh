#!/bin/bash


TMPDIR=foo
PATCH_DIR=/Users/kjg/Temp/DMG/ciao-dmg/CIAO_DMG
VER=4.18.0.Y
OS=`uname -m`
BUILD=2729
TAG=${VER}.$(date +%Y%m%d)

BACKGROUND=${PATCH_DIR}/install_w_readme.png
DS_STORE=${PATCH_DIR}/ciao-hack-DS_Store
README=${PATCH_DIR}/ciao-hack-README.txt

# Create conda environment in /Applications folder

#~ conda create -p /Applications/ciao-${VER} \
  #~ --copy --yes \
  #~ -c https://cxc.cfa.harvard.edu/conda/test -c conda-forge \
  #~ ciao=4.18.0 ciao-contrib sherpa=4.17.1 ds9 marx caldb_main

conda create -p /Applications/ciao-${VER} \
  --copy --yes \
  -c https://cxc-test.cfa.harvard.edu/conda/test -c conda-forge \
  ciao=="4.18.0.dev=*_${BUILD}" ciao-contrib sherpa=="4.17.1.dev=*_${BUILD}" ds9 marx caldb_main

# Move it to temp dir and patch in files

mkdir -p ${TMPDIR}
mv /Applications/ciao-${VER} ${TMPDIR}/
find ${TMPDIR}/ciao-${VER}  -type f \! -perm +u+w -exec chmod u+w {} \;

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
/bin/rm -f tmp_ciao-${VER}.dmg 
hdiutil create -size 19.1Gb -format UDRW  -fs HFS+J \
   -volname "CIAO ${VER}"  -srcfolder ${TMPDIR} tmp_ciao-${VER}.dmg 
   
# Add .DS_Store
hdiutil attach -readwrite tmp_ciao-${VER}.dmg
(cd "/Volumes/CIAO ${VER}"; cp -fv ${DS_STORE} .DS_Store)
hdiutil detach "/Volumes/CIAO ${VER}"

# Create final compressed, read-only image
rm ciao-${TAG}-${OS}.dmg
hdiutil convert tmp_ciao-${VER}.dmg -format UDZO -o ciao-${TAG}-${OS}.dmg

rm tmp_ciao-${VER}.dmg
/bin/rm -rf ${TMPDIR}
