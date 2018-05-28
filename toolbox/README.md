# DS Toolbox Service

To start DS Toolbox do following

Install Docker if it is not installed already.
https://www.docker.com/community-edition 

```sh
git clone https://github.com/sudachen/dstoolbox.git
cd dstoolbox
make up

# optional, edit evironment variables 
# DATABASE_URL and GITHUB_ACCESS_TOKEN
# or/and add other environment valiables
cd toolbox
nano docker-compose.yml
# setup environment variables as you wish, save and exit editor
cd ..
make up
````

The DS Toolbox will start automatically every time on Docker starting.
Jupyterlab is available on localhost:8888. This toolbox supports google  Colaboratory. Notebooks on google drive can be opened by Colaboratory and calculated on local DS toolbox, simple connect to a local runtime.

All locally created notebooks will be in 'work' directory in user home. 




