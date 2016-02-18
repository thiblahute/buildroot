################################################################################
#
# intelce-demux
#
################################################################################
INTELCE_DEMUX_VERSION = ${INTELCE_SDK_VERSION}
INTELCE_DEMUX_SITE = ${INTELCE_SDK_DIR}/empty
INTELCE_DEMUX_SITE_METHOD = local
INTELCE_DEMUX_LICENSE = PROPRIETARY
INTELCE_DEMUX_REDISTRIBUTE = NO
INTELCE_DEMUX_DEPENDENCIES = intelce-sdk intelce-system_utils intelce-clock_recovery intelce-pal intelce-auto_eas intelce-osal intelce-clock_control intelce-htuple intelce-smd_tools intelce-sven linux intelce-core intelce-api intelce-platform_config intelce-SMD_Common intelce-intel_ce_pm intelce-sec
INTELCE_DEMUX_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_INTELCE_SDK_V36),y)
    INTELCE_VIDPPROC_DEPENDENCIES += intelce-fw_load 
endif

INTELCE_DEMUX_BUILD_ENV = \
    BUILD_TARGET_DIR=${INTELCE_DEMUX_DIR} \
    BUILD_SMD_COMMOM=true BUILD_SMD_TOOLS=true  
    
define INTELCE_DEMUX_CONFIGURE_CMDS
   
endef

define INTELCE_DEMUX_BUILD_CMDS
    if [ -d "${INTELCE_DEMUX_DIR}/build_i686" ] ; then \
       rm -rf "${INTELCE_DEMUX_DIR}/build_i686"; \
    fi

    if [ -d "${INTELCE_DEMUX_DIR}/binaries" ] ; then \
       rm -rf "${INTELCE_DEMUX_DIR}/binaries" ; \
    fi
    
    if [ -d "${INTELCE_DEMUX_DIR}/project_build_i686" ] ; then \
       rm -rf "${INTELCE_DEMUX_DIR}/project_build_i686" ; \
    fi
    
    ${INTELCE_DEMUX_BUILD_ENV} ${INTELCESDK-BUILD} demux
endef

define INTELCE_DEMUX_INSTALL_STAGING_CMDS
    $(call INTELCE_SDK_INSTALL_TO_STAGING,${INTELCE_DEMUX_DIR}/build_i686/staging_dir) 
endef

define INTELCE_DEMUX_INSTALL_TARGET_CMDS
    $(call INTELCE_SDK_INSTALL_TO_TARGET,${INTELCE_DEMUX_DIR}/project_build_i686/IntelCE/root)
endef

$(eval $(generic-package))