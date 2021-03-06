#!/bin/bash
#
# Copyright 2017 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -o errexit

if [ "$#" -ne 1 ]; then
    echo Missing version parameter
    echo Usage: build-services.sh \<version\>
    exit 1
fi

VERSION=$1
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

pushd $SCRIPTDIR/productpage
  docker build -t examples-bookinfo-productpage-v1:${VERSION} -t examples-bookinfo-productpage-v1:latest .
popd

pushd $SCRIPTDIR/details
  #plain build -- no calling external book service to fetch topics
  docker build -t examples-bookinfo-details-v1:${VERSION} -t examples-bookinfo-details-v1:latest --build-arg service_version=v1 .
  #with calling external book service to fetch topic for the book
  docker build -t examples-bookinfo-details-v2:${VERSION} -t examples-bookinfo-details-v2:latest --build-arg service_version=v2 \
	 --build-arg enable_external_book_service=true .
popd

pushd $SCRIPTDIR/reviews
  #java build the app.
  docker run --rm -v `pwd`:/home/gradle/project -w /home/gradle/project gradle:4.8.1 gradle clean build
  pushd reviews-wlpcfg
    #plain build -- no ratings
    docker build -t examples-bookinfo-reviews-v1:${VERSION} -t examples-bookinfo-reviews-v1:latest --build-arg service_version=v1 .
    #with ratings black stars
    docker build -t examples-bookinfo-reviews-v2:${VERSION} -t examples-bookinfo-reviews-v2:latest --build-arg service_version=v2 \
	   --build-arg enable_ratings=true .
    #with ratings red stars
    docker build -t examples-bookinfo-reviews-v3:${VERSION} -t examples-bookinfo-reviews-v3:latest --build-arg service_version=v3 \
	   --build-arg enable_ratings=true --build-arg star_color=red .
  popd
popd

pushd $SCRIPTDIR/ratings
  docker build -t examples-bookinfo-ratings-v1:${VERSION} -t examples-bookinfo-ratings-v1:latest --build-arg service_version=v1 .
  docker build -t examples-bookinfo-ratings-v2:${VERSION} -t examples-bookinfo-ratings-v2:latest --build-arg service_version=v2 .
popd

pushd $SCRIPTDIR/mysql
  docker build -t examples-bookinfo-mysqldb:${VERSION} -t examples-bookinfo-mysqldb:latest .
popd

pushd $SCRIPTDIR/mongodb
  docker build -t examples-bookinfo-mongodb:${VERSION} -t examples-bookinfo-mongodb:latest .
popd
