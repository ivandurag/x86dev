# ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# Automatically-generated file. Do not edit!
LUM_ALL =  kernel kdi
LUM_SPEC_NAME = x86dev.spec
LUM_MKIMAGE_FLAGS =
LUM_KDI_NAME = x86dev.kdi
LUM_LYNXOS_BOOT = 

LUM_KERNEL_DIRECTORY = $(ENV_PREFIX)/sys/bsp.$(TARGET_BSP)
LUM_CONFIG_NAME = $(TARGET_BSP)/config.tbl
LUM_UPARAM_H = $(TARGET_BSP)/uparam.h

PWD := $(shell pwd)

## Configuration-related variables
# CFG directory
LUM_CFG_DIR = ./cfg.$(LYNXTARGET)
LUM_CONFIG = $(TARGET_BSP)/config.tbl
LUM_CONFIG_OUT = $(TARGET_BSP)/config.out
LUM_GENERATED_CONFIG = $(LUM_CONFIG_OUT) $(TARGET_BSP)/CONFIG.h \
             $(TARGET_BSP)/nodetab $(TARGET_BSP)/sysdevices.h

include $(ENV_PREFIX)/ENVIRONMENT

all: lcsconfig $(TARGET_BSP) $(LUM_CFG_DIR) $(LUM_ALL)

lcsconfig:
	(cd lcs; make INSTALL_DIR_CFG=$(PWD)/$(LUM_CFG_DIR) INSTALL_DIR_SYS_LIB=$(PWD)/lib install)

kernel: $(TARGET_BSP) $(LUM_CFG_DIR) $(TARGET_BSP)/a.out

clean: $(TARGET_BSP) $(LUM_CFG_DIR) $(LUM_OTHER_CLEAN)
	(cd lcs; make INSTALL_DIR_CFG=$(PWD)/$(LUM_CFG_DIR) INSTALL_DIR_SYS_LIB=$(PWD)/lib clean)
	@-cp $(TARGET_BSP)/VCT .
	@-cp $(TARGET_BSP)/$(LUM_SPEC_NAME) .
	(cd $(TARGET_BSP); make INSTALL_DIR_SYS_LIB=$(PWD)/lib clean)
	@-mv $(LUM_SPEC_NAME) $(TARGET_BSP)/$(LUM_SPEC_NAME)
	@-mv VCT $(TARGET_BSP)/VCT 

$(TARGET_BSP):
	mkdir -p $(TARGET_BSP)
	for i in $(LUM_KERNEL_DIRECTORY)/*; do \
	  n=`basename $$i`; \
	  if [ -d $$i ]; then \
	    if [ $$n != "CVS" ]; then \
	      cp -dpR $$i $(TARGET_BSP); \
	    fi; \
	    continue; \
	  fi; \
	  if [ $$n != "VCT.in" -a $$n != "lynxos-178.spec.in" -a $$n != lynxos-178.spec ]; \
	  then cp $$i $(TARGET_BSP); fi; \
	done

$(LUM_CFG_DIR):
	mkdir -p $(LUM_CFG_DIR)
	cp -pRL $(ENV_PREFIX)/sys/cfg/* $(LUM_CFG_DIR)

$(TARGET_BSP)/a.out: $(LUM_GENERATED_CONFIG) $(LUM_UPARAM_H) lcs/lcsinfo.c
	(cd $(TARGET_BSP); \
	 rm -f a.out; \
	 make INSTALL_DIR_SYS_LIB=$(PWD)/lib OTHER=$(OTHER) a.out)

ifneq ($(LUM_KDI_NAME),)
kdi: $(TARGET_BSP) $(TARGET_BSP)/$(LUM_SPEC_NAME) $(TARGET_BSP)/a.out Makefile
	rm -f $(TARGET_BSP)/$(LUM_KDI_NAME)
	(cd $(TARGET_BSP); \
	 make INSTALL_DIR_SYS_LIB=$(PWD)/lib KDI_NAME=$(LUM_KDI_NAME) SPEC_NAME=$(LUM_SPEC_NAME) MKIMAGE="mkimage $(LUM_MKIMAGE_FLAGS)" kdi)
	@if [ -f $(TARGET_BSP)/$(LUM_KDI_NAME) ]; then \
	  echo "**** KDI is successfully built ****"; \
	fi
endif

# Configuration-related staff
$(LUM_GENERATED_CONFIG): $(LUM_CONFIG)
	@make config

config: 
	@$(ECHO) Creating $(LUM_CONFIG_OUT) ...
	@$(ECHO) -n "m4 " > config.tmp
ifneq ($(RELEASE_FLAGS),)
	@for flag in $(RELEASE_FLAGS); \
	do \
	  $(ECHO) -n $$flag >> config.tmp; $(ECHO) -n "=1 " >> config.tmp; \
	done
endif
	@$(ECHO) -n " < $(LUM_CONFIG)" >> config.tmp
	@$(ECHO) " > $(LUM_CONFIG_OUT)" >> config.tmp
	@$(CHMOD) +x config.tmp
	@./config.tmp
	@$(RM) config.tmp
	@$(ECHO)
	@$(ECHO) Processing $(LUM_CONFIG_OUT) ...
	@$(ECHO)
	if [ -f local/passwd ]; then \
		config $(LUM_GENERATED_CONFIG) $(LUM_CFG_DIR) local/passwd $(ENV_PREFIX)/etc/group; \
	else \
		config $(LUM_GENERATED_CONFIG) $(LUM_CFG_DIR) $(ENV_PREFIX)/etc/passwd $(ENV_PREFIX)/etc/group; \
	fi
