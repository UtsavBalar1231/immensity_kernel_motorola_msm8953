#!/bin/bash

#set -e

DATE_POSTFIX=$(date +"%Y%m%d")

## Copy this script inside the kernel directory
KERNEL_DIR=$PWD
KERNEL_DEFCONFIG=potter_defconfig
DTB=$KERNEL_DIR/dtbtool/
JOBS=8
ZIP_DIR=$KERNEL_DIR/zip/
KERNEL=IMMENSITY-KERNEL
TYPE=HMP
RELEASE=ELOQUENCE-RELEASE
FINAL_KERNEL_ZIP=$KERNEL-$TYPE-$RELEASE-$DATE_POSTFIX.zip
# Speed up build process
MAKE="./makeparallel"

echo "INITIALIZE ALL THE DIRECTORIES"
cd
rm -rf IMMEN*
cd $ZIP_DIR
mkdir treble-unsupported
cd $KERNEL_DIR

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
#red
R='\033[05;31m'
#purple
P='\e[0;35m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo -e  "$P // Setting up Toolchain //"
export CROSS_COMPILE=~/gcc/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64


echo -e "$R _____________________"
echo " "
echo -e "$yellow        #  I  #"
echo -e "$yellow        #  M  #"
echo -e "$yellow        #  M  #"
echo -e "$yellow        #  E  #"
echo -e "$yellow 	#  N  #"
echo -e "$yellow        #  S  #"
echo -e "$yellow 	#  I  #"
echo -e "$yellow        #  T  #"
echo -e "$yellow 	#  Y  #"
echo -e "$nocol           |   "
echo -e "$yellow        #  K  #"
echo -e "$yellow        #  E  #"
echo -e "$yellow        #  R  #"
echo -e "$yellow        #  N  #"
echo -e "$yellow        #  E  #"
echo -e "$yellow        #  L  #"
echo -e "$R ____________________"

echo -e  "$R // Lets Clean up //"
sudo make clean && sudo make mrproper && rm -rf out/

echo -e "$cyan // defconfig is set to $KERNEL_DEFCONFIG //"
echo -e "$blue___________________________________________"
echo -e "$R          BUILDING IMMENSITY•KERNEL          "
echo -e "________________________________________________$nocol"

make $KERNEL_DEFCONFIG O=out
make -j$JOBS CC=~/clang/bin/clang-9 CLANG_TRIPLE=aarch64-linux-android- O=out

echo -e "$cyan_______________________"
 echo " // Generating DT.img //"
echo -e "____________________________$nocol"

$DTB/dtbToolCM -2 -o $KERNEL_DIR/out/arch/arm64/boot/dtb -s 2048 -p $KERNEL_DIR/out/scripts/dtc/ $KERNEL_DIR/out/arch/arm64/boot/dts/qcom/

echo -e "$R // Verify Image.gz //"
ls $KERNEL_DIR/out/arch/arm64/boot/Image.gz

echo -e "$R // Verify dtb //"
ls $KERNEL_DIR/out/arch/arm64/boot/dtb

echo -e "$R // Verifying zip Directory //"
ls $ZIP_DIR/

echo "// Removing leftovers //"
rm -rf $ZIP_DIR/Image.gz
rm -rf $ZIP_DIR/$FINAL_KERNEL_ZIP
rm -rf $ZIP_DIR/dtb

echo -e "$R // Copying Image.gz //"

cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz $ZIP_DIR/treble-unsupported/
echo -e "$R // Copying dtb //"
cp $KERNEL_DIR/out/arch/arm64/boot/dtb $ZIP_DIR/treble-unsupported/

echo -e "$R // Time to zip everything up! //"
cd $ZIP_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $KERNEL_DIR/zip/$FINAL_KERNEL_ZIP /home/utsavbalar1231/$FINAL_KERNEL_ZIP

echo -e "$yellow // Build Successfull  //"
cd $KERNEL_DIR
echo -e "$R // Cleaning up //"

rm -rf $ZIP_DIR/$FINAL_KERNEL_ZIP
rm -rf $ZIP_DIR/Image.gz
rm -rf $ZIP_DIR/dtb
rm -rf $ZIP_DIR/treble-unsupported
rm -rf $KERNEL_DIR/out/

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow IMMENSITY • KERNEL Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
