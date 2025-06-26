CONDA_PREFIX=/Applications/ciao-4.17
export CONDA_PREFIX

PATH="${CONDA_PREFIX}/bin:${PATH}"

for scrpt in ${CONDA_PREFIX}/etc/conda/activate.d/*.sh
do
  source "${scrpt}"
done

ciaover
