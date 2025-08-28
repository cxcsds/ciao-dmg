CIAO 4.18 macOS DMG archive

Step-by-step installation instructions:

1. You have completed it by downloading the .dmg file and double
   clicking to open it.

2. Drag the ciao-4.18 folder to Applications

3. Open the Terminal application and then run the following command

      xattr -cr /Applications/ciao-4.18

4. Source the CIAO setup script.

   If you are using the default zsh (or bash/ksh/similar)

      source /Applications/ciao-4.18/bin/ciao.sh

   If you are using the tcsh shell

      source /Applications/ciao-4.18/bin/ciao.csh

5. You can then run the CIAO smoke tests

      bash $ASCDS_INSTALL/test/smoke/bin/run_smoke_tests.sh


Notes and Limitations

1. You must install ciao-4.18 into the Applications folder.

2. The setup scripts are not the standard setup scripts you would get
   with either the "conda create" or the "ciao-install" installation
   options. The various flags are not available such as "-o" and "-q".

3. To update any CIAO component requires users uninstall the existing
   ciao-4.18 installation and replace it with the updated .dmg file.
   To uninstall CIAO simply drag the /Applications/ciao-4.18 folder to
   the Trash.


License

The CIAO software distribution contains software developed by the
Chandra X-Ray Center (Smithsonian Astrophysical Observatory and
contracted affiliates) and "off-the-shelf" software developed by
various third parties.

The CIAO software distribution is licensed for use under
the GNU General Public License (GPL) Version 3 (or at your option
any later version). The terms of the GNU General Public License
are described in the COPYING file in the root directory of the
$ASCDS_INSTALL tree.

Software developed solely by the Smithsonian Astrophysical
Observatory is copyright the Smithsonian Astrophysical Observatory
and is in addition licensed for use as described in the LICENSE.SAO
file in the root directory of the $ASCDS_INSTALL tree.


Copyrights

Copyright (c) 1999-2025 Smithsonian Astrophysical Observatory

Permission to use, copy, modify, distribute,  and  sell  this
software  and  its  documentation  for  any purpose is hereby
granted  without  fee,  provided  that  the  above  copyright
notice  appear  in  all  copies  and that both that copyright
notice and this permission notice appear in supporting  docu-
mentation,  and  that  the  name  of  the  Smithsonian Astro-
physical Observatory not be used in advertising or  publicity
pertaining  to distribution of the software without specific,
written  prior  permission.   The  Smithsonian  Astrophysical
Observatory  makes  no  representations about the suitability
of this software for any purpose.  It  is  provided  "as  is"
without express or implied warranty.

THE  SMITHSONIAN  ASTROPHYSICAL  OBSERVATORY  DISCLAIMS   ALL
WARRANTIES  WITH  REGARD  TO  THIS  SOFTWARE,  INCLUDING  ALL
IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND FITNESS, IN  NO
EVENT  SHALL  THE  SMITHSONIAN  ASTROPHYSICAL  OBSERVATORY BE
LIABLE FOR ANY SPECIAL,  INDIRECT  OR  CONSEQUENTIAL  DAMAGES
OR  ANY  DAMAGES  WHATSOEVER RESULTING FROM LOSS OF USE, DATA
OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,  NEGLIGENCE  OR
OTHER  TORTIOUS  ACTION, ARISING OUT OF OR IN CONNECTION WITH
THE USE OR PERFORMANCE OF THIS SOFTWARE.

