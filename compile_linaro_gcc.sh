#! /usr/bin/bash

_cross_compile="/data/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-"
_cross_compile="/data/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-"
_cross_compile_32=$(realpath "$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-")

_defconfig=aosp_${_platform}_${_device}_defconfig

echo "==> Entering $_kernel_path"
pushd "$_kernel_path" || (echo "ERROR: Failed to cd into kernel source!"; exit 1)

echo "==> Building $_defconfig"
make $_make_vars $_defconfig

echo "==> Building $_targets with Linaro gcc"
echo $_make_vars CROSS_COMPILE="$_cross_compile" $_targets
time make $_make_vars CROSS_COMPILE="$_cross_compile" CROSS_COMPILE_ARM32="$_cross_compile_32" $_targets

echo "==> $_targets compiled successfully"
popd
