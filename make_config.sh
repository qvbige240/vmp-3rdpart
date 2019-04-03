#!/bin/bash

WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "WORKDIR: $WORKDIR "
echo "BUILD_PATH: $BUILD_PATH "
#echo "${BASH_SOURCE[0]}"
#echo "$( dirname "${BASH_SOURCE[0]}" )"

export zlog_SRC=${WORKDIR}/zlog-1.2.7
export librtmp_SRC=${WORKDIR}/rtmpdump	#librtmp-2.4
export libevent_SRC=${WORKDIR}/libevent-2.1.8-stable

export sqlite_SRC=${WORKDIR}/sqlite-autoconf-3190300
export jansson_SRC=${WORKDIR}/jansson-2.10
export curl_SRC=${WORKDIR}/curl-7.52.1

export nanomsg_SRC=${WORKDIR}/nanomsg-1.0.0

# the include file of zlog needed attention
function build_zlog()
{
    echo "#####################    Build zlog   #####################"
    echo "   "
    #cd ${BUILD_PATH}
    #rm -rf *
    cd ${zlog_SRC}
    make clean
    make
    make PREFIX=${FINAL_PATH} install 
}

function build_librtmp()
{
    echo "#####################    Build librtmp   #####################"
    echo "   "
    cd ${BUILD_PATH}
    rm -rf *
    cd ${librtmp_SRC}      #
    #make SYS=posix CRYPTO= XDEF=-DNO_SSL prefix=${FINAL_PATH}
    #make SYS=posix CRYPTO= XDEF=-DNO_SSL prefix=/home/zouqing/osource/network/pc/test
    #export prefix=/home/zouqing/osource/network/pc/test
    make clean
    make SYS=posix CRYPTO= XDEF=-DNO_SSL
    make prefix=${FINAL_PATH} install
}



function build_sqlite()
{
    echo "#####################    Build sqlite   #####################"
    echo "   "
    echo "cd ${BUILD_PATH}"
    cd ${BUILD_PATH}
    rm -rf *
    ${sqlite_SRC}/configure --prefix=${FINAL_PATH} --host=$TARGETMACH \
        --with-pic enable_threadsafe=yes
    make
    make install
}

function build_jansson()
{
    # need config
    cd ${jansson_SRC}
    /usr/bin/libtoolize
    /usr/bin/aclocal
    /usr/bin/autoconf
    /usr/bin/autoheader
    /usr/bin/automake --add-missing
    cd -

    echo "#####################    Build jansson   #####################"
    echo "   "
    echo "cd ${BUILD_PATH}"
    cd ${BUILD_PATH}
    rm -rf *
    ${jansson_SRC}/configure --prefix=${FINAL_PATH} --host=$TARGETMACH
    make
    make install
}

function build_curl()
{
    # nt966x use the target .so
    echo "#####################    Build curl   #####################"
    echo "   "
    echo "cd ${BUILD_PATH}"
    cd ${BUILD_PATH}
    rm -rf *
    #${curl_SRC}/configure --prefix=${FINAL_PATH} --host=$TARGETMACH --with-zlib
    ${curl_SRC}/configure --prefix=${FINAL_PATH} --host=$TARGETMACH --without-zlib 
    make
    make install
}

function build_libevent()
{
    echo "#####################    Build libevent   #####################"
    echo "   "
    echo "cd ${BUILD_PATH}"
    cd ${BUILD_PATH}
    rm -rf *
    #cd ${libevent_SRC}
    #${libevent_SRC}/autogen.sh
    ${libevent_SRC}/configure --prefix=${FINAL_PATH} --host=$TARGETMACH --disable-clock-gettime
    make
    #    make verify
    make install
}

function build_nanomsg()
{
    echo "#####################    Build nanomsg   #####################"
    echo "   "
    echo "cd ${BUILD_PATH}"
    cd ${BUILD_PATH}
    rm -rf *
    if [ -f ${nanomsg_SRC}/${TARGETMACH}.cmake ]; then
        cmake -DCMAKE_TOOLCHAIN_FILE=${nanomsg_SRC}/${TARGETMACH}.cmake -DCMAKE_INSTALL_PREFIX=${FINAL_PATH} ${nanomsg_SRC}
    else
        cmake -DCMAKE_INSTALL_PREFIX=${FINAL_PATH} ${nanomsg_SRC}
    fi
    make
    make install
}

build_jansson
#build_zlog
#build_librtmp
#build_libevent

if false; then
build_sqlite
build_zlog
build_jansson
build_curl
fi
