#! /usr/bin/bash

if (( "$#" != 1 )); then
	print 'Usage: ./oot/common.sh <device> (Example for akatsuki: ./oot/common.sh akatsuki)'
	exit
fi

_device="$1"


# Device specific
case ${_device} in
discovery|pioneer)
	_platform=nile
	;;
mermaid)
	_platform=ganges
	;;
akatsuki)
	_platform=tama
	;;
bahamut|griffin)
	_platform=kumano
	;;
*)
	print "Device ${_device} unknown or not implemented"
	exit
	;;
esac


# Platform common
BOARD_KERNEL_BASE=0x00000000
BOARD_KERNEL_PAGESIZE=4096
BOARD_KERNEL_TAGS_OFFSET=0x01E00000
BOARD_RAMDISK_OFFSET=0x02000000

BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} lpm_levels.sleep_disabled=1"
BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} service_locator.enable=1"

# Platform specific
case ${_platform} in
nile|ganges)
	_verity_file=build/target/product/security/verity.x509.pem
	_verity_key_id=$(openssl x509 -in $_verity_file -text | grep keyid | sed 's/://g' | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed 's/keyid//g')
	;;
tama)
	_has_dtbo=true

	BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} swiotlb=2048"
	BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} msm_drm.dsi_display0=dsi_panel_somc_tama_cmd:config0"
	;;
kumano)
	_has_dtbo=true

	BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} swiotlb=2048"
	BOARD_KERNEL_CMDLINE="${BOARD_KERNEL_CMDLINE} msm_drm.blhack_dsi_display0=dsi_panel_somc_kumano_cmd:config0"
	;;
esac


# Options
# _permissive=true
_compiler=linaro_gcc

_self_dir=$(realpath $(dirname "$0"))
. $_self_dir/compile.sh
