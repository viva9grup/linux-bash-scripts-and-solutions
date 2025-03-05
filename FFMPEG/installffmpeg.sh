# TODO: Verify to link statically some dependencies usually not available in a default instllation of RHEL/CentOS (ex.: libxcb)

###################
## Configuration ##
###################

FFMPEG_CPU_COUNT=$(nproc)
FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-libfreetype"
FFMPEG_HOME=/usr/local/src/ffmpeg

####################
## Initialization ##
####################

apt-get -y install autoconf automake1.11 cmake libfreetype6-dev gcc g++ git libtool make mercurial nasm pkg-config nettle-dev libgmp-dev libfontconfig-dev libcurl4-openssl-dev libssl-dev libncurses5-dev libp11-kit-dev zlib1g-dev

mkdir -p ${FFMPEG_HOME}/src
mkdir -p ${FFMPEG_HOME}/build
mkdir -p ${FFMPEG_HOME}/bin

export PATH=$PATH:${FFMPEG_HOME}/build:${FFMPEG_HOME}/build/lib:${FFMPEG_HOME}/build/include:${FFMPEG_HOME}/bin

##############
### FFMPEG ###
##############

/bin/echo
/bin/echo -e "\e[93mCompiling YASM...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg-nonfree/build" --bindir="${FFMPEG_HOME}/bin"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

/bin/echo
/bin/echo -e "\e[93mCompiling fontconfig...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.94.tar.gz
tar xzvf fontconfig-2.11.94.tar.gz
rm -f fontconfig-2.11.94.tar.gz
cd fontconfig-2.11.94
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --enable-libxml2
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-fontconfig"

/bin/echo
/bin/echo -e "\e[93mCompiling libfribidi...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://fribidi.org/download/fribidi-0.19.7.tar.bz2
tar xjvf fribidi-0.19.7.tar.bz2
rm -f fribidi-0.19.7.tar.bz2
cd fribidi-0.19.7
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfribidi"

/bin/echo
/bin/echo -e "\e[93mCompiling libass...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/libass/libass.git
cd libass
./autogen.sh
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libass"

/bin/echo
/bin/echo -e "\e[93mCompiling libcaca...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/cacalabs/libcaca.git
cd libcaca
git checkout v0.99.beta19
./bootstrap
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --disable-doc  --disable-ruby --disable-csharp --disable-java --disable-python --disable-cxx --enable-ncurses --disable-x11
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libcaca"

/bin/echo
/bin/echo -e "\e[93mCompiling libvo-amrwbenc...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz
tar xzvf vo-amrwbenc-0.1.3.tar.gz
rm -f vo-amrwbenc-0.1.3.tar.gz
cd vo-amrwbenc-0.1.3
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvo-amrwbenc"

/bin/echo
/bin/echo -e "\e[93mCompiling libopencore...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.3.tar.gz
tar xzvf opencore-amr-0.1.3.tar.gz
rm -f opencore-amr-0.1.3.tar.gz
cd opencore-amr-0.1.3
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopencore-amrnb --enable-libopencore-amrwb"

/bin/echo
/bin/echo -e "\e[93mCompiling libx264...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://git.videolan.org/git/x264.git
cd x264
git checkout origin/stable
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx264"

/bin/echo
/bin/echo -e "\e[93mCompiling libx265...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
hg clone https://bitbucket.org/multicoreware/x265
cd ${FFMPEG_HOME}/src/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DENABLE_SHARED:bool=off ../../source
make -j ${FFMPEG_CPU_COUNT}
make install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libx265"

/bin/echo
/bin/echo -e "\e[93mCompiling libfdk-aac...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
git clone --depth 1 https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
autoreconf -fiv
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libfdk-aac"

/bin/echo
/bin/echo -e "\e[93mCompiling libmp3lame...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
rm -f lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static --enable-nasm
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libmp3lame"

/bin/echo
/bin/echo -e "\e[93mCompiling libtwolame...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz
tar xzvf twolame-0.3.13.tar.gz
rm -f twolame-0.3.13.tar.gz
cd twolame-0.3.13
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtwolame"

/bin/echo
/bin/echo -e "\e[93mCompiling libopus...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopus"

/bin/echo
/bin/echo -e "\e[93mCompiling libogg...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
rm -f libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

/bin/echo
/bin/echo -e "\e[93mCompiling libvorbis...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
rm -f libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L${FFMPEG_HOME}/build/lib" CPPFLAGS="-I${FFMPEG_HOME}/build/include" ./configure --prefix="${FFMPEG_HOME}/build" --with-ogg="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvorbis"

/bin/echo
/bin/echo -e "\e[93mCompiling libspeex...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/speex/speex-1.2rc2.tar.gz
tar xzvf speex-1.2rc2.tar.gz
rm -f speex-1.2rc2.tar.gz
cd speex-1.2rc2
LDFLAGS="-L${FFMPEG_HOME}/build/lib" CPPFLAGS="-I${FFMPEG_HOME}/build/include" ./configure --prefix="${FFMPEG_HOME}/build" --with-ogg="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libspeex"

/bin/echo
/bin/echo -e "\e[93mCompiling libvpx...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="${FFMPEG_HOME}/build" --disable-examples  --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make clean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvpx"

/bin/echo
/bin/echo -e "\e[93mCompiling libxvid...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz
tar xvfz xvidcore-1.3.2.tar.gz
rm -f xvidcore-1.3.2.tar.gz
cd xvidcore/build/generic
./configure --prefix="${FFMPEG_HOME}/build" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libxvid"

/bin/echo
/bin/echo -e "\e[93mCompiling libtheora...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
rm -f libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="${FFMPEG_HOME}/build" --disable-oggtest --with-ogg-includes="${FFMPEG_HOME}/build/include" --with-ogg-libraries="${FFMPEG_HOME}/build/lib" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libtheora"

/bin/echo
/bin/echo -e "\e[93mCompiling libwebp...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://chromium.googlesource.com/webm/libwebp.git
cd libwebp
./autogen.sh
./configure --prefix="${FFMPEG_HOME}/build" --bindir="${FFMPEG_HOME}/bin" --disable-shared --enable-static
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libwebp"

/bin/echo
/bin/echo -e "\e[93mCompiling libopenjpeg...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/uclouvain/openjpeg.git
cd openjpeg
git checkout openjpeg-2.1
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
rm -f -R "${FFMPEG_HOME}/build/lib/openjpeg-2.1"
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libopenjpeg"

/bin/echo
/bin/echo -e "\e[93mCompiling libilbc...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/TimothyGu/libilbc.git
cd libilbc
sed 's/lib64/lib/g' -i CMakeLists.txt
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0 -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=/lib
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libilbc"

/bin/echo
/bin/echo -e "\e[93mCompiling librtmp...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone --depth 1 https://git.ffmpeg.org/rtmpdump.git librtmp || git clone --depth 1 git://git.ffmpeg.org/rtmpdump librtmp || git clone --depth 1 https://github.com/ossrs/librtmp.git librtmp
cd librtmp
make -j ${FFMPEG_CPU_COUNT} SYS=posix prefix="${FFMPEG_HOME}/build" CRYPTO=OPENSSL SHARED= XCFLAGS="-I${FFMPEG_HOME}/build/include" XLDFLAGS="-L${FFMPEG_HOME}/build/lib" install
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librtmp"

/bin/echo
/bin/echo -e "\e[93mCompiling libsoxr...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone http://git.code.sf.net/p/soxr/code soxr
cd soxr
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DWITH_OPENMP=off -DWITH_LSR_BINDINGS=off -DBUILD_SHARED_LIBS=0 -DBUILD_EXAMPLES=0 -DBUILD_TESTS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libsoxr"

/bin/echo
/bin/echo -e "\e[93mCompiling frei0r...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
curl -L -O https://files.dyne.org/frei0r/snapshots/frei0r-snapshot-27-01-15.tar.gz
tar xzvf frei0r-snapshot-27-01-15.tar.gz
rm -f frei0r-snapshot-27-01-15.tar.gz
mv frei0r-snapshot-27-01-15 frei0r-plugins-snapshot-1.5
cd frei0r-plugins-snapshot-1.5
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0 -DCMAKE_BUILD_TYPE=Release -DWITHOUT_OPENCV=ON -DWITHOUT_GAVL=ON
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-frei0r --enable-filter=frei0r"

/bin/echo
/bin/echo -e "\e[93mCompiling libvidstab...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/georgmartius/vid.stab.git vidstab
cd vidstab
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-libvidstab"

/bin/echo
/bin/echo -e "\e[93mCompiling librubberband...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/lachs0r/rubberband.git
cd rubberband
make -j ${FFMPEG_CPU_COUNT} PREFIX="${FFMPEG_HOME}/build" install-static
FFMPEG_ENABLE="${FFMPEG_ENABLE} --enable-librubberband"

# Full "--enable" list, just in case
# FFMPEG_ENABLE="--enable-gpl --enable-version3 --enable-nonfree --enable-runtime-cpudetect --enable-gray --enable-openssl --enable-libfreetype --enable-fontconfig --enable-libfribidi --enable-libass --enable-libcaca --enable-libvo-amrwbenc --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libx265 --enable-libfdk-aac --enable-libmp3lame --enable-libtwolame --enable-libopus --enable-libvorbis --enable-libspeex --enable-libvpx --enable-libxvid --enable-libtheora --enable-libwebp --enable-libopenjpeg --enable-libilbc --enable-librtmp --enable-libsoxr --enable-frei0r --enable-filter=frei0r --enable-libvidstab --enable-librubberband"

/bin/echo
/bin/echo -e "\e[93mCompiling ffmpeg...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
#git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build" --extra-cflags="-I${FFMPEG_HOME}/build/include" --extra-ldflags="-L${FFMPEG_HOME}/build/lib" --extra-libs='-lnettle -lhogweed -lgmp -lncurses' --bindir="${FFMPEG_HOME}/bin" --pkg-config-flags="--static" ${FFMPEG_ENABLE}
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
hash -r


#################
### MEDIAINFO ###
#################

/bin/echo
/bin/echo -e "\e[93mCompiling zenlib...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/ZenLib zenlib
cd zenlib/Project/CMake
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DLIB_INSTALL_DIR="${FFMPEG_HOME}/build/lib" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean

/bin/echo
/bin/echo -e "\e[93mCompiling mediainfolib...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/MediaInfoLib mediainfolib
cd mediainfolib/Project/CMake
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${FFMPEG_HOME}/build" -DLIB_INSTALL_DIR="${FFMPEG_HOME}/build/lib" -DBUILD_SHARED_LIBS=0
make -j ${FFMPEG_CPU_COUNT}
make install
sed -i 's|libzen|libcurl librtmp libzen|' "${FFMPEG_HOME}/build/lib/pkgconfig/libmediainfo.pc"
make distclean

/bin/echo
/bin/echo -e "\e[93mCompiling mediainfo...\e[39m"
/bin/echo
cd ${FFMPEG_HOME}/src
git clone https://github.com/MediaArea/MediaInfo mediainfo
cd mediainfo/Project/GNU/CLI
./autogen.sh
PKG_CONFIG_PATH="${FFMPEG_HOME}/build/lib/pkgconfig" ./configure --prefix="${FFMPEG_HOME}/build"
make -j ${FFMPEG_CPU_COUNT}
make install
make distclean
