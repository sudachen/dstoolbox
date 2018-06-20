export REVISION := 1.14
export BASE_REVISION := $(REVISION)
export OWNER := sudachen

DEFAULT = jupy2r
all: up

jupyter.Build:
	IMAGE=$(basename $@) $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker build
jupyter.Update:
	IMAGE=$(basename $@) $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker update

jupy2r.Build: jupyter.Build
	IMAGE=$(basename $@) BASE_IMAGE=$(basename $<) $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker build
jupy2r.Update: 
	IMAGE=$(basename $@) BASE_IMAGE=$(basename $<) BASE_REVISION=latest $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker update

%.Push:
	docker push ${OWNER}/$(basename $@):${REVISION}
	docker tag ${OWNER}/$(basename $@):${REVISION} ${OWNER}/$(basename $@):latest
	docker push ${OWNER}/$(basename $@):latest

%.Up:
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up up	
%.Run: 
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up run	

build: $(DEFAULT).Build
update: $(DEFAULT).Update
up: $(DEFAULT).Up
push: $(DEFAULT).Push 
down: 
	$(MAKE) -C toolbox -f $(PWD)/Makefile.up down