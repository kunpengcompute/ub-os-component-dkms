kernelver ?= $(shell uname -r)
KERNEL_PATH ?= /lib/modules/$(kernelver)/build
EXTRA_CFLAGS += -I$(PWD)/include
MOD_SRC_TREE := $(PWD)

obj-m += drivers/ub/
obj-m += drivers/iommu/hisilicon/
obj-m += drivers/firmware/uvb/
obj-m += drivers/fwctl/ub/
obj-m += drivers/perf/hisilicon/
obj-m += drivers/vfio/ubus/
obj-m += drivers/net/ub/

MODULES_CONFIG = \
	CONFIG_FWCTL_UB=m \
	CONFIG_OBMM=m \
	CONFIG_UB_CDMA=m \
	CONFIG_UB_HISI_UBUS=m \
	CONFIG_UB_SENTRY=m \
	CONFIG_UB_SENTRY_REMOTE=m \
	CONFIG_UB_UBASE=m \
	CONFIG_UB_UBFI=m \
	CONFIG_UB_UBDEVSHM=m \
	CONFIG_UB_UBMEMPFD=m \
	CONFIG_UB_UBL=m \
	CONFIG_UB_UBUS_BUS=m \
	CONFIG_UB_UDMA=m \
	CONFIG_UB_UMMU=m \
	CONFIG_UB_UMMU_SVA=y \
	CONFIG_UB_UMMU_BYPASSEID=y \
	CONFIG_UB_UBMEM_UMMU=y \
	CONFIG_UB_UMMU_CORE_DRIVER=m \
	CONFIG_UB_UMMU_SVA_SEPARATED_PAGES=y \
	CONFIG_UB_UMMU_PMU=m \
	CONFIG_UB_UBMEM_VMMU=m \
	CONFIG_UB_NET=y \
	CONFIG_UB_UNIC=m \
	CONFIG_UB_UNIC_DCB=y \
	CONFIG_UB_UNIC_UBL=y \
	CONFIG_UB_URMA=m \
	CONFIG_UDFI_CIS=m \
	CONFIG_UDFI_ODF=m \
	CONFIG_VFIO_UB=m

EXTRA_CFLAGS += $(patsubst %=y,-D%=1,$(filter %=y,$(MODULES_CONFIG)))
EXTRA_CFLAGS += $(patsubst %=m,-D%_MODULE=1,$(filter %=m,$(MODULES_CONFIG)))

all:
	$(MAKE) -C $(KERNEL_PATH) M=$(PWD) MOD_SRC_TREE=$(MOD_SRC_TREE) modules $(MODULES_CONFIG) EXTRA_CFLAGS="$(EXTRA_CFLAGS)"


clean:
	$(MAKE) -C $(KERNEL_PATH) M=$(PWD) clean
