CIAO 4.17.0 macOS DMG archive

Step-by-step installation instructions:

1. You have completed it by downloading the .dmg file and double
   clicking to open it.
   
2. Drag the ciao-4.17 folder to Applications 

3. Open the Terminal application and then run the following command

      xattr -cr /Applications/ciao-4.17
      
   You can ignore the permission warnings/errors.

4. Source the CIAO setup script.

   If you are using the default zsh (or bash/ksh/similar)
  
      source /Applications/ciao-4.17/bin/ciao.sh
  
   If you are using the tcsh shell 
  
      source /Applications/ciao-4.17/bin/ciao.csh

5. You can then run the CIAO smoke tests

      bash $ASCDS_INSTALL/test/smoke/bin/run_smoke_tests.sh
      

Notes and Limitations

1. You must install ciao-4.17 into the Applications folder.

2. The setup scripts are not the standard setup scripts you would get
   with either the "conda create" or the "ciao-install" installation
   options. 
  
   - The various flags are not available such as "-o" and "-q".
   - During the smoke tests the ciao version (ciaover output) will
     be displayed repeated. This is expected.

3. 
     
     
      
