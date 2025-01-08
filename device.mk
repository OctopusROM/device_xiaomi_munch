#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# A/B
TARGET_IS_VAB := true

# Inherit from sm8250-common
$(call inherit-product, device/xiaomi/sm8250-common/kona.mk)

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Boot animation
TARGET_BOOT_ANIMATION_RES := 1080

# Camera
PRODUCT_PACKAGES += \
    libpiex_shim

# Overlays
PRODUCT_PACKAGES += \
    FrameworksOverlay \
    SettingsOverlay \
    SystemUIOverlay \
    SettingsOverlay22021211RC \
    SettingsOverlay22021211RG \
    SettingsOverlay22021211RI \
    SettingsProviderOverlay22021211RC \
    SettingsProviderOverlay22021211RG \
    SettingsProviderOverlay22021211RI \
    WifiOverlay22021211RC \
    WifiOverlay22021211RG \
    WifiOverlay22021211RI \
    ApertureOverlay

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 31

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit from vendor blobs
$(call inherit-product, vendor/xiaomi/munch/munch-vendor.mk)
