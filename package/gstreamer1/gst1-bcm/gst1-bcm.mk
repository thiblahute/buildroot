################################################################################
#
# gst1-bcm
#
################################################################################

ifeq ($(BR2_PACKAGE_BCM_REFSW_16_1),y)
GST1_BCM_VERSION = 16.1
else ifeq ($(BR2_PACKAGE_BCM_REFSW_16_2),y)
GST1_BCM_VERSION = 16.2
else ifeq ($(BR2_PACKAGE_BCM_REFSW_17_4),y)
GST1_BCM_VERSION = 17.3-rdkv-20180327
else ifeq ($(BR2_PACKAGE_BCM_REFSW_17_1),y)
GST1_BCM_VERSION = 17.1-7
else ifeq ($(BR2_PACKAGE_BCM_REFSW_17_1_RDK),y)
GST1_BCM_VERSION = 17.1
else ifeq ($(BR2_PACKAGE_BCM_REFSW_17_3_RDK),y)
GST1_BCM_VERSION = 17.1-7
else ifneq ($(filter y,$(BR2_PACKAGE_ACN_SDK) $(BR2_PACKAGE_HOMECAST_SDK)),)
GST1_BCM_VERSION = 17.1-5
else ifneq ($(filter y,$(BR2_PACKAGE_VSS_SDK)),)
GST1_BCM_VERSION = dd00f0762b7dfed4e4e657482d085e554201fa48
else
GST1_BCM_VERSION = 15.2
endif

GST1_BCM_SITE = git@github.com:Metrological/gstreamer-plugins-soc.git
GST1_BCM_SITE_METHOD = git
GST1_BCM_LICENSE = PROPRIETARY
GST1_BCM_DEPENDENCIES = gstreamer1 gst1-plugins-base libcurl mpg123

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
GST1_BCM_DEPENDENCIES += bcm-refsw
else
BCM_REFSW_MAKE_ENV = \
	REFSW_DIR="refsw" \
	B_REFSW_CROSS_COMPILE=${BR2_TOOLCHAIN_EXTERNAL_PREFIX}-

NEXUS_CFLAGS=$(shell cat ${STAGING_DIR}/usr/include/refsw/platform_app.inc | grep NEXUS_CFLAGS | cut -d' ' -f3- | awk -F "-std=c89" '{print $$1 $$2}')
NEXUS_LDFLAGS=$(shell cat ${STAGING_DIR}/usr/include/refsw/platform_app.inc | grep NEXUS_LDFLAGS | cut -d' ' -f3-)
NEXUS_CLIENT_LD_LIBRARIES=$(shell cat ${STAGING_DIR}/usr/include/refsw/platform_app.inc | grep NEXUS_CLIENT_LD_LIBRARIES | cut -d' ' -f4-)

CFLAGS = $(TARGET_CFLAGS) ${NEXUS_CFLAGS}
LDFLAGS = -L${STAGING_DIR}/usr/lib $(NEXUS_LDFLAGS) $(NEXUS_CLIENT_LD_LIBRARIES)
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_VP9_SUPPORT),y)
CFLAGS += -DVP9_SUPPORT
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_WPEFRAMEWORK_CDM),y)
GST1_BCM_DEPENDENCIES += wpeframework
CFLAGS += -DGST_BRCM_WPEFRAMEWORK_CDM
endif
GST1_BCM_AUTORECONF = YES

GST1_BCM_CONF_ENV += \
	$(BCM_REFSW_MAKE_ENV) \
	GSTREAMER_REFSW_SERVER_NXCLIENT_SUPPORT=y \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR)

GST1_BCM_MAKE_ENV += \
	$(BCM_REFSW_MAKE_ENV) \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR)

GST1_BCM_MAKE_OPTS += "\
	CFLAGS+=${CFLAGS} \
		-std=c99 \
		-I${BCM_REWSW_BIN}/include \
		-I${BCM_REFSW_DIR}/BSEAV/api/include \
		-I${BCM_REFSW_DIR}/BSEAV/lib/media/ \
		-I${STAGING_DIR}/usr/include/refsw/" \
		"LDFLAGS+=${LDFLAGS}"

GST1_BCM_CONF_OPTS = \
	--enable-gstreamer1  \
	--enable-shared \
	--with-pic \
	--disable-static \
	--enable-systemclock \
	--disable-avi \
	--disable-flv \
	--disable-httpsrc \
	--disable-ivfparse \
	--disable-matroska \
	--disable-mp3swdecode \
	--disable-mp4demux \
	--enable-pcmsink \
	--disable-pesdemux \
	--disable-playback \
	--disable-qtdemux \
	--disable-transcode \
	--disable-tsdemux \
	--disable-tsparse \
	--disable-playersinkbin \
	--disable-gfxsink

ifeq ($(BR2_PACKAGE_GST1_BCM_AUDFILTER),y)
GST1_BCM_CONF_OPTS += --enable-audfilter
else
GST1_BCM_CONF_OPTS += --disable-audfilter
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_AUDIODECODE),y)
GST1_BCM_CONF_OPTS += --enable-audiodecode
else
GST1_BCM_CONF_OPTS += --disable-audiodecode
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_AUDIOSINK),y)
GST1_BCM_CONF_OPTS += --enable-audiosink
else
GST1_BCM_CONF_OPTS += --disable-audiosink
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_VIDEODECODE),y)
GST1_BCM_CONF_OPTS += --enable-videodecode
else
GST1_BCM_CONF_OPTS += --disable-videodecode
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_VIDEOSINK),y)
GST1_BCM_CONF_OPTS += --enable-videosink
else
GST1_BCM_CONF_OPTS += --disable-videosink
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_VIDFILTER),y)
GST1_BCM_CONF_OPTS += --enable-vidfilter
else
GST1_BCM_CONF_OPTS += --disable-vidfilter
endif

ifeq ($(BR2_PACKAGE_GST1_BCM_ENABLE_SVP),y)
GST1_BCM_CONF_OPTS += --enable-svp
endif

ifeq ($(BR2_PACKAGE_HAS_OPUS_DECODER),)
GST1_BCM_PKGDIR = "$(TOP_DIR)/package/gstreamer1/gst1-bcm"

define GST1_BCM_APPLY_LOCAL_PATCHES
 $(APPLY_PATCHES) $(@D) $(GST1_BCM_PKGDIR) 0001_remove_opus_support.patch.conditional;
endef
  
GST1_BCM_POST_PATCH_HOOKS += GST1_BCM_APPLY_LOCAL_PATCHES 
endif

$(eval $(autotools-package))
