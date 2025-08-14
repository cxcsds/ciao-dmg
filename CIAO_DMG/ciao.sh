
CONDA_PREFIX=/Applications/ciao-@VER@
export CONDA_PREFIX

PATH="${CONDA_PREFIX}/bin:${PATH}"

_SKIP=yes
if test x$ASCDS_INSTALL = "x"
then
  _SKIP=no
fi

for scrpt in ${CONDA_PREFIX}/etc/conda/activate.d/*.sh
do
  source "${scrpt}"
done

if test $_SKIP = "no"
then
	ciaover
fi
unset _SKIP
