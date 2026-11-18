#!/bin/bash


TMPDIR=foo
PATCH_DIR=/Users/kjg/Temp/DMG/ciao-dmg/CIAO_DMG
VER=4.18
OS=`uname -m`
#BUILD=2729
#TAG=${VER}.$(date +%Y%m%d)
TAG=${VER}.0-2a

BACKGROUND=${PATCH_DIR}/install_w_readme.png
README=${PATCH_DIR}/ciao-hack-README.txt
DMG_SETTINGS=${PATCH_DIR}/dmg_settings.py

# dmgbuild (pip install dmgbuild) writes the .DS_Store (background,
# icon size/positions) so no manual Finder step is needed.
if ! command -v dmgbuild > /dev/null ; then
  echo "ERROR: dmgbuild not found; install with 'pip install dmgbuild'" 1>&2
  exit 1
fi

# Create conda environment in /Applications folder

#~ conda create -p /Applications/ciao-${VER} \
  #~ --copy --yes \
  #~ -c https://cxc.cfa.harvard.edu/conda/test -c conda-forge \
  #~ ciao=4.18.0 ciao-contrib sherpa=4.17.1 ds9 marx caldb_main

conda create -p /Applications/ciao-${VER} \
  --copy --yes \
  -c https://cxc.cfa.harvard.edu/conda/ciao -c conda-forge \
  ciao=="4.18.0" sherpa=="4.18.0" \
  ds9 marx caldb_main=4.12.4 ciao-contrib=4.18.2 numpy=2.3.5

# Move it to temp dir and patch in files

mkdir -p ${TMPDIR}
mv /Applications/ciao-${VER} ${TMPDIR}/
find ${TMPDIR}/ciao-${VER}  -type f \! -perm +u+w -exec chmod u+w {} \;

cp ${README} ${TMPDIR}/README.txt

# --------------------
# Add in setup scripts

sed "s/@VER@/${VER}/" ${PATCH_DIR}/ciao.sh > ${TMPDIR}/ciao-${VER}/bin/ciao.sh
sed "s/@VER@/${VER}/" ${PATCH_DIR}/ciao.csh > ${TMPDIR}/ciao-${VER}/bin/ciao.csh

# -------------------

# Create compressed, read-only disk image.  dmgbuild adds the
# background image, /Applications symlink, and .DS_Store, and
# computes the image size from the contents.

rm -f ciao-${TAG}-${OS}.dmg
dmgbuild -s ${DMG_SETTINGS} \
  -D ver=${VER} -D tmpdir=${TMPDIR} -D background=${BACKGROUND} \
  "CIAO ${VER}" ciao-${TAG}-${OS}.dmg || exit 1

/bin/rm -rf ${TMPDIR}
