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
ip.run_cell('import sys, os, os.path')

ip.run_cell('''
for k, v in os.environ.items():
    if k.endswith('_CONN'):
       globals()[k.upper()] = v
''')

ip.run_cell('''
from singleton_decorator import singleton

@singleton
def GDrive():
    from pydrive.auth import GoogleAuth
    from pydrive.drive import GoogleDrive
    from google.colab import auth
    from oauth2client.client import GoogleCredentials

    # 1. Authenticate and create the PyDrive client.
    auth.authenticate_user()
    gauth = GoogleAuth()
    gauth.credentials = GoogleCredentials.get_application_default()
    return GoogleDrive(gauth)

''')
