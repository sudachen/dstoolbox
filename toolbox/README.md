# DS Toolbox Service

To start DS Toolbox do following:

Firstly, install Docker if it is not installed already.
https://www.docker.com/community-edition   
On Windows I use legacy `Docker Toolbox` https://docs.docker.com/toolbox/toolbox_install_windows/   
It's based on VirtualBox and does not prohibit the use of another VM software except microsoft Hyper-V. 

Then run the setup script. If you are a Windows user, execute it in the `Docker Quickstart Terminal`!
```sh
curl -s https://raw.githubusercontent.com/sudachen/dstoolbox/master/dstoolbox-setup.sh | sh
```

Or, if you familiar with Git, you can play with repo

```sh
git clone https://github.com/sudachen/dstoolbox.git
cd dstoolbox
make up
```

It's quite ALL, however you can configure more

```sh
# optional, edit evironment variables 
# DATABASE_URL and GITHUB_ACCESS_TOKEN
# or/and add other environment valiables
nano ~/.dstoolbox/docker-compose.yml
# after changes you have to rebuild jupyter service
sh ~/.dstoolbox/up
````

The DS Toolbox will start automatically with Docker when Docker is starting. You have not to start DS Toolbox every time, just start Docker or enable Docker to start automatically at system boot time.

Jupyterlab is available on localhost:8888. This toolbox supports google  Colaboratory. Notebooks on google drive can be opened by Colaboratory and calculated on local DS toolbox, just connect it to the local runtime on 8888 port.

All locally created notebooks will be in 'work' directory in user home. 

If you use legacy `Docker Toolbox`, you have to change IP in port bindings declared in ~/.dstoolbox/docker-compose.yml from 127.0.0.1 to 0.0.0.0. And, of course, do not forget to add required port mapping in default VM by VirtualBox.

![](https://github.com/sudachen/dstoolbox/raw/master/docs/assets/virtualbox_ports.png)
