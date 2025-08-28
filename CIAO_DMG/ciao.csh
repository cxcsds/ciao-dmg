setenv CONDA_PREFIX /Applications/ciao-@VER@

set path = (${CONDA_PREFIX}/bin $path)

set _RUN=yes
if ($?ASCDS_INSTALL) then
    set _RUN=no
endif

foreach scrpt (${CONDA_PREFIX}/etc/conda/activate.d/*.csh)
  source "${scrpt}"
end

if ($_RUN == "yes") then
	ciaover
endif

unset _RUN
