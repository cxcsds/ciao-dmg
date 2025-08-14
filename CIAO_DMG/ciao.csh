setenv CONDA_PREFIX /Applications/ciao-@VER@

set path = (${CONDA_PREFIX}/bin $path)

set _SKIP=no
if ($?ASCDS_INSTALL) then
    set _SKIP=yes
endif


foreach scrpt (${CONDA_PREFIX}/etc/conda/activate.d/*.csh)
  source "${scrpt}"
end

if ($_SKIP == "no") then
	ciaover
endif
