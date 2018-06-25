export REVISION := 1.15
export BASE_REVISION := $(REVISION)
export OWNER := sudachen

DEFAULT = jupy2r
ALL = jupyter jupy2r
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

%.Pull:
	docker pull ${OWNER}/$(basename $@):${REVISION}
	docker pull ${OWNER}/$(basename $@):latest
%.Up:
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up up	
%.Run: 
	$(MAKE) IMAGE=$(basename $@) -C toolbox -f $(PWD)/Makefile.up run	

build:  $(DEFAULT).Build
update: $(DEFAULT).Update
up:     $(DEFAULT).Up
push:   $(DEFAULT).Push 
pull:   $(foreach img, $(ALL), $(img).Pull)

retag:  
	docker pull ${OWNER}/jupyter:latest
	docker tag ${OWNER}/jupyter:latest ${OWNER}/jupyter:${REVISION}
	docker push ${OWNER}/jupyter:${REVISION}

down: 
	$(MAKE) -C toolbox -f $(PWD)/Makefile.up down
