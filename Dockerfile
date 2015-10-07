FROM ubuntu:15.04

# Inspired from https://github.com/heikomaass/docker-android/blob/master/android-sdk/Dockerfile

MAINTAINER Fabian Köster <fabian.koester@bringnow.com>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386

# The file .dockercacheupdated is compared by docker to the last one
# in order to decide if the cache needs to be invalidated. If you want to
# force docker to update the cache, execute
# "date -R > .docker_cache_last_updated"
ADD .docker_cache_last_updated /

# Update package list
RUN apt-get update -qq

# Update packages
RUN apt-get upgrade -y

# Install required packages
RUN apt-get install -y expect
RUN apt-get install -y --no-install-recommends openjdk-8-jdk
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends libncurses5:i386 libstdc++6:i386 zlib1g:i386
RUN apt-get install -y --no-install-recommends maven
RUN apt-get install -y --no-install-recommends git # needed by gitlab-runner
RUN apt-get install -y --no-install-recommends npm # needed to install cordova

ENV ANDROID_SDK_VERSION 24.3.4
ENV ANDROID_HOME /opt/android-sdk-linux

# Install Android SDK installer
RUN curl -O http://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz
RUN tar xf android-sdk*.tgz -C /opt
RUN rm android-sdk*.tgz

COPY tools /opt/sdk-tools

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/sdk-tools

# Install Android SDK components
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter tools --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter platform-tools --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-23.0.1\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-android-support\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"android-23\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"addon-google_apis-google-23\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"sys-img-armeabi-v7a-addon-google_apis-google-23\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-android-m2repository\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-google-m2repository\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-google-google_play_services\" --no-ui --force -a"]

RUN apt-get clean
