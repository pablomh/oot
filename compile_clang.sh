#! /usr/bin/bash

_clang_path=$(realpath "$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r353983c1/bin/")
_cross_compile_path=$(realpath "$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/")
_cross_compile_32_path=$(realpath "$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/")

export PATH="$_clang_path:$_cross_compile_path:$_cross_compile_32_path:${PATH}"

_defconfig=aosp_${_platform}_${_device}_defconfig

echo "==> Entering $_kernel_path"
pushd "$_kernel_path" || (echo "ERROR: Failed to cd into kernel source!"; exit 1)

echo "==> Building $_defconfig"
make $_make_vars $_defconfig

echo "==> Building $_targets with clang"
make $_make_vars CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- $_targets

echo "==> $_targets compiled successfully"
popd
