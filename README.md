# Create macOS .dmg installer for CIAO

This repro contains a script and artifacts needed create a macOS .dmg
file to install CIAO 4.17 (including full CALDB, sans source code) into
the /Applications folder.

## Walk through steps


### 1. Install CIAO using `conda`

Since `ciao-install` is borked, we use `conda` to install CIAO.

**It must be installed in `/Applications/ciao-4.17` so we use the `-p` (prefix)
flag**

```bash
conda create -p /Applications/ciao-${VER} \
  --copy --yes \
  -c https://cxc.cfa.harvard.edu/conda/ciao -c conda-forge \
  ciao pyciao ciao-contrib sherpa ds9 marx caldb 
```

Note: you could add `ciao-src pyciao-src sherpa-src` if we wanted that.

---

### 2. Relocate and patch in files

To create the `.dmg` file we need to have a folder with 

- ciao-4.17
- symlink to Applications folder

We can also add a background image that can be used to tell the user
how to install (Drag folder to Applications).

We also made a copy of the instructions and put them into a README.txt

```bash
mkdir ${TMPDIR}
mv /Applications/ciao-${VER} ${TMPDIR}/

mkdir ${TMPDIR}/.background
cp ${BACKGROUND} ${TMPDIR}/.background

cp ${README} ${TMPDIR}/README.txt

ln -s /Applications ${TMPDIR}/
```

---

#### 2.1 Patch in setup scripts: `ciao.sh` and `ciao.csh`

This is a conda environment and does not use ciao.*sh for setup.

Instead is uses the files in the ciao-4.17/etc/conda/activate.d/*sh .

So I wrote two simple replacement setup scripts that source all the 
setup scripts in the activate.d directory. 

To emulate the ciao-install setup scripts they also call the ciaover
command. (The conda setup does not show the ciaover when the environment
is activated).

```bash
cp ${PATCH_DIR}/ciao.*sh ${TMPDIR}/ciao-${VER}/bin/
```

---

### 3 Create disk image (ie .dmg file)

Thanks to reviewing the `ds9` `Makefile`, I learned about the `hdiutil`
command that can be used to create disk images via the command line and
manipulate them (create, attach, detach, convert). 

First we need to create a read+write version of the .dmg

```bash
/bin/rm -f tmp_ciao-${VER}.0.dmg 
hdiutil create -size 19.1Gb -format UDRW -fs HFS+J \
   -volname "CIAO ${VER}.0"  -srcfolder ${TMPDIR} tmp_ciao-${VER}.0.dmg 
```

The `-size 19.1Gb` is sufficient for CIAO 4.17 but will need to be reviewed/revised
for future releases.  `fs` = "file system" , `HFS+J` is the macOS file system. 
`UDRW` creates a read+write format disk image.

#### 3.1 Set background image/patch in .DS_Store file

This step needs to be done manually the first time (or any time the
background image changes).

First we need to attach (ie open) the disk image we just created.

```
hdiutil attach -readwrite tmp_ciao-${VER}.0.dmg
```

It will show up as a drive on the desktop.

---

##### 3.1.1 First time


Double click on the drive will open it in Finder.

You will see the ciao-4.17 folder, the Applications folder symbolic link, 
and the README.txt file.

Hit `Cmd+Shift+.` which will show the hidden files/folders.   Double click to
open the `.background` folder in a new Finder window.

Go back the original .dmg Finder window and right click. Select `Show View Options`
and in the `Background Options` select Picture.  Now drag the image 
`install_w_readme.png` to the background option. You should now see the
installation instruction background 

Close the `.background` finder window and hit `Cmd+Shift+.` to hide 
hidden files/folders.

Now re-arrange, resize icons & window as desired. 

When done close the Finder window but do not eject the image yet.

Open the Terminal applications and copy the hidden, system `.DS_Store` file

```bash
cd "/Volumes/CIAO ${VER}.0"
cp .DS_Store ~/ciao-hack-DS_Store
```

This file contains all the information about the icon location, size,
background, window size, etc.  Upshot: you can save this file and then
next time you want to create the image, you just need to copy
this file into place.

---

##### 3.3.2 After the first time

After the first time manually creating the `.DS_Store` file you can then
just copy it onto the disk image. _This is why the disk image needed to be
created read+write_.  Note: Trying to copy the .DS_Store before the disk image
is created doesn't work (or didn't work for me) so this requires this extra step.

```bash
(cd "/Volumes/CIAO ${VER}.0"; cp -fv ${DS_STORE} .DS_Store)
```

---

### 4. Finish

First we detach the temp image now that the .DS_Store file has been created/copied.

```bash
hdiutil detach "/Volumes/CIAO ${VER}.0"
```

and finally we can create the compressed, read-only disk image


```bash
rm ciao-${VER}.0-${OS}.dmg
hdiutil convert tmp_ciao-${VER}.0.dmg -format UDZO -o ciao-${VER}.0-${OS}.dmg

rm tmp_ciao-${VER}.0.dmg
```

You may also want to go ahead and remove the `${TMPDIR}`

## Summary

Be sure to review/add/edit the `README.txt` file to make sure it matches
the release. 
