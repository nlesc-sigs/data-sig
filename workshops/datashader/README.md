# Data shader

http://datashader.org

Using same dataset as in ../cartodb-fdw

```
conda env create -f environment.yml
conda activate datashader
jupyter labextension install @pyviz/jupyterlab_pyviz jupyterlab_bokeh jupyter-matplotlib dask-labextension @jupyter-widgets/jupyterlab-manager
jupyter lab
```

Open bird-download.ipynb notebook and then bird-holo.ipynb.
