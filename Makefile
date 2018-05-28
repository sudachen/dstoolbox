export REVISION = 1.2
export OWNER = sudachen

DEFAULT = jupyter_jx2
all: up

jupyter:
	IMAGE=$@ $(MAKE) -C base -f $(PWD)/Makefile.docker build

jupyter_r: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C r -f $(PWD)/Makefile.docker next
jupyter_2: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C 2 -f $(PWD)/Makefile.docker next
jupyter_j: jupyter
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C j -f $(PWD)/Makefile.docker next
jupyter_jx: jupyter_j
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C x -f $(PWD)/Makefile.docker next
jupyter_jx2: jupyter_jx
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C 2 -f $(PWD)/Makefile.docker next
jupyter_jx2r: jupyter_jx2
	IMAGE=$@ BASE_IMAGE=$< $(MAKE) -C r -f $(PWD)/Makefile.docker next

%.Push: % 
	docker push ${OWNER}/$(basename $@):${REVISION}
	docker push ${OWNER}/$(basename $@):latest
%.Up: %
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up up	
%.Run: 
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up run	

build: $(DEFAULT)
up: $(DEFAULT).Up
push: jupyter.Push jupyter_jx.Push jupyter_jx2.Push jupyter_jx2r.Push
down: 
	$(MAKE) -C toolbox -f $(PWD)/Makefile.up down
