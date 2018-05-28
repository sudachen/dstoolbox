export REVISION = 1.3
export OWNER = sudachen

DEFAULT = jupyter_r2jx
all: up

jupyter:
	IMAGE=$@ $(MAKE) -C base -f $(PWD)/Makefile.docker build

jupyter_r: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C r -f $(PWD)/Makefile.docker next
jupyter_2: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C 2 -f $(PWD)/Makefile.docker next
jupyter_j: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C j -f $(PWD)/Makefile.docker next

jupyter_r: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C r -f $(PWD)/Makefile.docker next
jupyter_r2: jupyter_r
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C 2 -f $(PWD)/Makefile.docker next
jupyter_r2j: jupyter_r2
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C j -f $(PWD)/Makefile.docker next
jupyter_r2jx: jupyter_r2j
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C x -f $(PWD)/Makefile.docker next

%.Push: % 
	docker push ${OWNER}/$(basename $@):${REVISION}
	docker push ${OWNER}/$(basename $@):latest
%.Up: %
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up up	
%.Run: 
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up run	

build: $(DEFAULT)
up: $(DEFAULT).Up
push: jupyter_r2j.Push jupyter_r2jx.Push
down: 
	$(MAKE) -C toolbox -f $(PWD)/Makefile.up down
