from IPython import get_ipython
ip = get_ipython()

ip.magic('automagic off')
ip.magic('load_ext sql')
ip.magic('load_ext autoreload')
ip.magic('matplotlib inline')
ip.magic('config SqlMagic.autopandas = True')

ip.run_cell('import matplotlib.pyplot as plt')
ip.run_cell('import numpy as np')
ip.run_cell('import pandas as pd')


