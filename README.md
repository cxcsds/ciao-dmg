# Create macOS .dmg installer for CIAO

This repro contains a script and artifacts needed create a macOS .dmg
file to install CIAO 4.18 (including full CALDB, sans source code) into
the /Applications folder.

## Walk through steps


### 1. Install CIAO using `conda`

Since `ciao-install` is borked, we use `conda` to install CIAO.

**It must be installed in `/Applications/ciao-4.18` so we use the `-p` (prefix)
flag**

```bash
conda create -p /Applications/ciao-${VER} \
  --copy --yes \
  -c https://cxc.cfa.harvard.edu/conda/ciao -c conda-forge \
  ciao ciao-contrib sherpa ds9 marx caldb_main numpy=2.3.5
```

Note: you could add `ciao-src sherpa-src` if we wanted that.
We decided to drop acis and hrc blank sky background files.

---

### 2. Relocate and patch in files

To create the `.dmg` file we need to have a folder with 

- ciao-4.18
- README.txt

We made a copy of the instructions and put them into a README.txt.
The background image (which tells the user how to install: drag folder
to Applications) and the symlink to the Applications folder are added
by `dmgbuild` in step 3.

```bash
mkdir ${TMPDIR}
mv /Applications/ciao-${VER} ${TMPDIR}/
find ${TMPDIR}/ciao-${VER}  -type f \! -perm +u+w -exec chmod u+w {} \;

cp ${README} ${TMPDIR}/README.txt
```

The `find` command was added to chmod the read-only files as they
cause warnings when running `xattr`.

---

#### 2.1 Patch in setup scripts: `ciao.sh` and `ciao.csh`

This is a conda environment and does not use ciao.*sh for setup.

Instead is uses the files in the ciao-4.18/etc/conda/activate.d/*sh .

So I wrote two simple replacement setup scripts that source all the 
setup scripts in the activate.d directory. 

To emulate the ciao-install setup scripts they also call the ciaover
command. (The conda setup does not show the ciaover when the environment
is activated).

```bash
cp ${PATCH_DIR}/ciao.*sh ${TMPDIR}/ciao-${VER}/bin/
```

---

### 3. Create disk image (ie .dmg file)

We use [`dmgbuild`](https://github.com/dmgbuild/dmgbuild) to create the
disk image.  It must be run on macOS.  Install it with

```bash
pip install dmgbuild
```

`dmgbuild` creates the image, copies in the files (using `ditto`, which
preserves symlinks, permissions, and extended attributes), adds the
`/Applications` symlink and background image, and writes the hidden
`.DS_Store` file that sets the window size, background, and icon
size/positions.  It then converts it to a compressed (`UDZO`), read-only
image.  The image size is computed from the contents.

```bash
rm -f ciao-${TAG}-${OS}.dmg
dmgbuild -s ${PATCH_DIR}/dmg_settings.py \
  -D ver=${VER} -D tmpdir=${TMPDIR} -D background=${BACKGROUND} \
  "CIAO ${VER}" ciao-${TAG}-${OS}.dmg
```

If the computed size is ever too small, add e.g. `-D size=20g`.

#### 3.1 Changing the layout

The Finder window layout lives in `CIAO_DMG/dmg_settings.py`:

- `window_rect` -- window position and size, `((x, y), (width, height))`
- `icon_size`, `text_size` -- icon and label sizes
- `icon_locations` -- position of each item in the window
- `background` -- passed in on the command line (`install_w_readme.png`)

The current values were taken from the `.DS_Store` file that was
originally made by hand in Finder (`CIAO_DMG/ciao-hack-DS_Store`, kept
for reference but no longer used).  If the background image changes,
adjust `window_rect` and `icon_locations` to match.

One way to find new values: mount a built image read+write, arrange
the window in Finder, then use the `ds_store` Python package (installed
with `dmgbuild`) to print the `.DS_Store` contents:

```bash
hdiutil convert ciao-${TAG}-${OS}.dmg -format UDRW -o tmp_ciao.dmg
hdiutil attach -readwrite tmp_ciao.dmg
# ... arrange the window in Finder, then close it ...
python3 -c '
import sys
import ds_store.store
ds_store.store.codecs.pop(b"pBBk", None)  # some bookmarks fail to decode
from ds_store import DSStore
with DSStore.open(sys.argv[1]) as d:
    for e in d:
        if e.code in (b"Iloc", b"bwsp"):
            print(e.filename, e.code, e.value)
' "/Volumes/CIAO ${VER}/.DS_Store"
hdiutil detach "/Volumes/CIAO ${VER}"
rm tmp_ciao.dmg
```

`Iloc` gives the icon positions and `WindowBounds` in `bwsp` gives
`window_rect`.

---

### 4. Finish

Remove the `${TMPDIR}`

```bash
/bin/rm -rf ${TMPDIR}
```

## Summary

Be sure to review/add/edit the `README.txt` file to make sure it matches
the release. 
