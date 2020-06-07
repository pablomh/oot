#! /usr/bin/bash

_cross_compile=$(realpath "$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-")
_cross_compile_32=$(realpath "$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-")
_clang_path=$(realpath "$ANDROID_ROOT/prebuilts/clang/host/linux-x86/")
_clang_path=$(ls -1d "$_clang_path/clang-r"*/bin | tail -1)
echo "==> Using clang $_clang_path"

_defconfig=aosp_${_platform}_${_device}_defconfig

echo "==> Entering $_kernel_path"
pushd "$_kernel_path" || (echo "ERROR: Failed to cd into kernel source!"; exit 1)

echo "==> Building $_defconfig"
make $_make_vars $_defconfig

echo "==> Building $_targets with clang"
make $_make_vars CROSS_COMPILE="$_cross_compile" CROSS_COMPILE_ARM32="$_cross_compile_32" CC="${_clang_path}/clang" CLANG_TRIPLE=aarch64-linux-gnu $_targets

echo "==> $_targets compiled successfully"
popd
