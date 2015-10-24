LZMA_BIN := $(shell which lzma > )


$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_uncompressed_ramdisk) \
		$(recovery_kernel)
	@echo -e ${CL_CYN}"----- Compressing recovery ramdisk with lzma ------"${CL_RST}
	$(hide) rm -f $(recovery_uncompressed_ramdisk)
	$(LZMA_BIN) $(recovery_uncompressed_ramdisk)
	$(hide) rsync -a $(recovery_uncompressed_ramdisk) $(recovery_ramdisk)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	@echo -e ${CL_CYN}"----- Made recovery image -------- $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)


$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
