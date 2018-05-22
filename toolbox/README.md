# DS Toolbox Service

To start DS Toolbox do following

Install Docker if it is not installed already.
https://www.docker.com/community-edition 

```sh
git clone git@github.com:sudachen/dstoolbox.git
cd dstoolbox/toolbox
cp docker-compose.in.yml docker-compose.yml
nano docker-compose.yml
# setup environment variables, save and exit editor
docker-compose up --build -d
````

The DS Toolbox will start automatically every time on Docker starting.
Jupyterlab is available on localhost:8888. This toolbox supports google  Colaboratory. Notebooks on google drive can be opened by Colaboratory and calculated on local DS toolbox, simple connect to a local runtime.




