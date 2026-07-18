#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q img2pdf | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_PYTHON=1
export ICON=DUMMY
export DESKTOP=DUMMY
export MAIN_BIN=img2pdf

# Deploy dependencies
quick-sharun \
	/usr/bin/img2pdf-gui*      \
	/usr/lib/libtk8*.so*       \
	/usr/lib/libtcl*.so        \
	/usr/lib/tk8*              \
	/usr/lib/tcl8*             \
	/usr/lib/libwebp.so*       \
	/usr/lib/libimagequant.so* \
	/usr/lib/libopenjp2.so*    \
	/usr/lib/libjpeg.so*       \
	/usr/lib/libtiff.so*       \
	/usr/lib/libpng*.so*       \
	/usr/lib/libwebp.so*       \
	/usr/lib/libjbig.so*       \
	/usr/lib/libp11-kit.so*    \
	/usr/lib/libqpdf.so*       \
	/usr/lib/libglib-*.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
