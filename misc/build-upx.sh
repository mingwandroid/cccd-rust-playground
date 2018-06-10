#!/usr/bin/env bash

_THISDIR=$(dirname ${BASH_SOURCE[0]})
if [ "${_THISDIR:0:1}" != "/" ]; then
  _THISDIR=$(cd ${_THISDIR} && pwd)
fi
if [ "${_THISDIR:0:1}" != "/" ]; then
  echo "ERROR :: this-dir not absolute, strange .."
  exit 1
fi

# Already built
if [[ -f ${_THISDIR}/$(uname)-$(uname -m)/upx ]]; then
  echo "Already built: ${_THISDIR}/$(uname)-$(uname -m)/upx"
  exit 0
fi

pushd /tmp
  git clone https://github.com/upx/upx
  cd upx
  git submodule update --init --recursive

  curl -SLO http://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz
  tar -xf ucl-1.03.tar.gz
  ROOT=${PWD}
  pushd ucl-1.03
    # From: https://github.com/mxe/mxe/pull/1358/commits/28dd97f3902fcb664c28255a2773839a4a897a2a
    # .. we may need this on x86_64 too though?
    if [[ $(uname -m) == i686 ]]; then
      export CFLAGS="${CFLAGS} -std=c90 -fPIC"
      export CXXFLAGS="${CXXFLAGS} -DUCL_NO_ASM"
    fi
    CONDA_BUILD_SYSROOT=/opt/MacOSX10.9.sdk ./configure --enable-static --disable-shared --disable-asm --prefix=${ROOT}/ucl-prefix
    CONDA_BUILD_SYSROOT=/opt/MacOSX10.9.sdk make install
  popd
  cp ${CONDA_PREFIX}/include/z{lib,conf}.h ${ROOT}/ucl-prefix/include
  cp ${CONDA_PREFIX}/lib/libz.a ${ROOT}/ucl-prefix/lib

  CONDA_BUILD_SYSROOT=/opt/MacOSX10.9.sdk LDFLAGS="${LDFLAGS} -L${ROOT}/ucl-prefix/lib" CXXFLAGS="${CXXFLAGS} -I${ROOT}/ucl-prefix/include" CFLAGS="${CFLAGS} -I${ROOT}/ucl-prefix/include" make all
  [[ -d ${_THISDIR}/$(uname)-$(uname -m) ]] || mkdir ${_THISDIR}/$(uname)-$(uname -m)
  find . -name "upx.out" -exec cp {} ${_THISDIR}/$(uname)-$(uname -m)/upx \;
popd

echo "Successfully built: ${_THISDIR}/$(uname)-$(uname -m)/upx"
