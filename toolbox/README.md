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

The DS Toolbox will start automatically every time on Docker starting


