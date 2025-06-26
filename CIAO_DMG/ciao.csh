setenv CONDA_PREFIX /Applications/ciao-4.17

set path = (${CONDA_PREFIX}/bin $path)

foreach scrpt (${CONDA_PREFIX}/etc/conda/activate.d/*.csh)
  source "${scrpt}"
end

ciaover
