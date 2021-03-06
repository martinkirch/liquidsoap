#!/bin/sh

set -e

SYSTEM=$1
BRANCH=$2
RELEASE=$GITHUB_SHA
OCAML_VERSION=4.11.1

DEPS_IMAGE="savonet/liquidsoap-win32-deps-${SYSTEM}"
BASE_IMAGE="savonet/liquidsoap-win32-base-${SYSTEM}"
IMAGE="savonet/liquidsoap-win32-${SYSTEM}"
COMMIT_SHORT=`echo "${GITHUB_SHA}" | cut -c-7`

if [ "${SYSTEM}" = "x64" ]; then
  HOST="x86_64-w64-mingw32.static"
  BUILD="${BRANCH}-win64"
  PKG_CONFIG_PATH="/usr/src/mxe/usr/x86_64-w64-mingw32.static/lib/pkgconfig/"
else
  HOST="i686-w64-mingw32.static"
  BUILD="${BRANCH}-win32"
  PKG_CONFIG_PATH="/usr/src/mxe/usr/i686-w64-mingw32.static/lib/pkgconfig/"
fi

docker build -f .github/docker/Dockerfile.win32-deps -t ${BASE_IMAGE} --no-cache \
  --build-arg IMAGE=${DEPS_IMAGE} --build-arg RELEASE=${RELEASE} .
docker build -f .github/docker/Dockerfile.win32 -t ${IMAGE} --no-cache \
  --build-arg IMAGE=${BASE_IMAGE} --build-arg HOST=${HOST} --build-arg BUILD=${BUILD} \
  --build-arg PKG_CONFIG_PATH=${PKG_CONFIG_PATH} --build-arg RELEASE=${RELEASE} .
id=$(docker create ${IMAGE})
docker cp ${id}:/tmp/liquidsoap-${BUILD}.zip .
docker rm -v ${id}
echo "##[set-output name=basename;]liquidsoap-${BUILD}"
