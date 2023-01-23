#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from proprietary files for miuicamera
-include vendor/xiaomi/munch-miuicamera/products/board.mk

DEVICE_PATH := device/xiaomi/munch

BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_DUP_RULES := true

# A/B
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a76

# Audio
AUDIO_FEATURE_ENABLED_AHAL_EXT := false
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := false
AUDIO_FEATURE_ENABLED_DTS_EAGLE := false
AUDIO_FEATURE_ENABLED_DYNAMIC_LOG := false
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := false
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SSR := false
BOARD_SUPPORTS_OPENSOURCE_STHAL := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true
USE_CUSTOM_AUDIO_POLICY := 1

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := munch
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 440
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS := 0x546C00000000
TARGET_NO_RAW10_CUSTOM_FORMAT := true
TARGET_USES_COLOR_METADATA := true
TARGET_USES_DISPLAY_RENDER_INTENTS := true
TARGET_USES_DRM_PP := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_GRALLOC4 := true
TARGET_USES_HWC2 := true
TARGET_USES_ION := true
TARGET_USES_VULKAN := true

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    $(DEVICE_PATH)/framework_compatibility_matrix.xml \
    vendor/aosp/config/device_framework_matrix.xml
DEVICE_MATRIX_FILE += $(DEVICE_PATH)/compatibility_matrix.xml
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml
ODM_MANIFEST_SKUS += nfc
ODM_MANIFEST_NFC_FILES := $(DEVICE_PATH)/manifest_nfc.xml

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_munch
TARGET_RECOVERY_DEVICE_MODULES := libinit_munch

# Kernel
BOARD_BOOT_HEADER_VERSION := 3
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.console=ttyMSM0 androidboot.memcg=1 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=2048 loop.max_part=7 cgroup.memory=nokmem,nosocket reboot=panic_warm
BOARD_KERNEL_CMDLINE += androidboot.fstab_suffix=qcom
BOARD_KERNEL_CMDLINE += androidboot.init_fatal_reboot_target=recovery
BOARD_KERNEL_CMDLINE += kpti=off
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_KERNEL_PAGESIZE := 4096
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
TARGET_KERNEL_SOURCE := kernel/xiaomi/munch
TARGET_KERNEL_CONFIG := munch_defconfig
TARGET_KERNEL_LLVM_BINUTILS := false
BOARD_RAMDISK_USE_LZ4 := true

# Partitions
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
ifeq ($(TARGET_IS_VAB),true)
BOARD_BOOTIMAGE_PARTITION_SIZE := 201326592
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
else
BOARD_BOOTIMAGE_PARTITION_SIZE := 134217728
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 134217728
endif
BOARD_DTBOIMG_PARTITION_SIZE := 33554432
ifneq ($(TARGET_IS_VAB),true)
BOARD_CACHEIMAGE_PARTITION_SIZE := 402653184
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif
BOARD_USERDATAIMAGE_PARTITION_SIZE := 114135379968
BOARD_USES_METADATA_PARTITION := true

PRODUCT_FS_COMPRESSION := 1

SSI_PARTITIONS := product system system_ext
TREBLE_PARTITIONS := odm vendor
ALL_PARTITIONS := $(SSI_PARTITIONS) $(TREBLE_PARTITIONS)

$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Partitions - dynamic
BOARD_SUPER_PARTITION_SIZE := 9126805504
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := $(ALL_PARTITIONS)
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 9122611200 # ( BOARD_SUPER_PARTITION_SIZE - 4MB )

# Partitions - reserved size
ifneq ($(WITH_GMS),true)
$(foreach p, $(call to-upper, $(SSI_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_EXTFS_INODE_COUNT := -1))
FRAMEWORK_PARTITIONS_RESERVED_SIZE := 1258291200
else
FRAMEWORK_PARTITIONS_RESERVED_SIZE := 30720000
endif
$(foreach p, $(call to-upper, $(SSI_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := $(FRAMEWORK_PARTITIONS_RESERVED_SIZE)))
$(foreach p, $(call to-upper, $(TREBLE_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := 30720000))

# Platform
BOARD_VENDOR := xiaomi
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := kona

# Power
TARGET_TAP_TO_WAKE_NODE := "/sys/touchpanel/double_tap"

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/properties/odm.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/properties/product.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/properties/system.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/properties/system_ext.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/properties/vendor.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

# Security patch level
VENDOR_SECURITY_PATCH := 2022-08-01

# Sepolicy
include device/qcom/sepolicy_vndr-legacy-um/SEPolicy.mk
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true
#SELINUX_IGNORE_NEVERALLOWS := true

# Touch
SOONG_CONFIG_NAMESPACES += XIAOMI_TOUCH
SOONG_CONFIG_XIAOMI_TOUCH := HIGH_TOUCH_POLLING_PATH
SOONG_CONFIG_XIAOMI_TOUCH_HIGH_TOUCH_POLLING_PATH := /sys/devices/virtual/touch/touch_dev/bump_sample_rate

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_VBMETA_SYSTEM := $(SSI_PARTITIONS)
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT := true

# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_FEATURE_HOSTAPD_11AX := true
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Inherit the proprietary files
include vendor/xiaomi/munch/BoardConfigVendor.mk
