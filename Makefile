export REVISION := 1.19
export BASE_REVISION := $(REVISION)
export OWNER := sudachen

BASE = jupyter
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
	IMAGE=$(basename $@) BASE_IMAGE= BASE_REVISION=latest $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker update

julia.Build: jupy2r.Build
	IMAGE=$(basename $@) BASE_IMAGE=$(basename $<) $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker build
julia.Update: 
	IMAGE=$(basename $@) BASE_IMAGE= BASE_REVISION=latest $(MAKE) -C $(basename $@) -f $(PWD)/Makefile.docker update

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
update: $(BASE).retag $(DEFAULT).Update
up:     $(DEFAULT).Up
push:   $(foreach img, $(ALL), $(img).Push) 
pull:   $(foreach img, $(ALL), $(img).Pull)

jupyter.retag:  
	docker pull ${OWNER}/jupyter:latest
	docker tag ${OWNER}/jupyter:latest ${OWNER}/jupyter:${REVISION}
	docker push ${OWNER}/jupyter:${REVISION}

jupy2r.retag: jupyter.retag 
	docker pull ${OWNER}/jupy2r:latest
	docker tag ${OWNER}/jupy2r:latest ${OWNER}/jupy2r:${REVISION}
	docker push ${OWNER}/jupy2r:${REVISION}

down: 
	$(MAKE) -C toolbox -f $(PWD)/Makefile.up down
