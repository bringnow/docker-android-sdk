FROM ubuntu:16.04

# Inspired from https://github.com/heikomaass/docker-android/blob/master/android-sdk/Dockerfile

MAINTAINER Fabian Köster <fabian.koester@bringnow.com>

ENV ANDROID_SDK_VERSION 24.4.1
ENV ANDROID_HOME /opt/android-sdk-linux

RUN dpkg --add-architecture i386

# Update package list
RUN apt-get update -qq

# Install required packages (git required by gitlab-runner)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends expect openjdk-8-jdk curl libncurses5:i386 libstdc++6:i386 zlib1g:i386 maven git python build-essential

# Install nodejs 5.x for Cordova, React Native etc.
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs

# Some dependencies need a 'node' executable, so link it to 'nodejs'
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Install Android SDK installer
RUN curl -O http://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz && \
    tar xf android-sdk*.tgz -C /opt  && \
    rm android-sdk*.tgz

COPY tools /opt/sdk-tools

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/sdk-tools

# Install Android SDK components
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter tools --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter platform-tools --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-23.0.1\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-23.0.2\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-23.0.3\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-24.0.2\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-24.0.3\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"build-tools-25.2.2\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-android-support\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"android-22\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"android-23\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"android-24\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"addon-google_apis-google-23\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-android-m2repository\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-google-m2repository\" --no-ui --force -a"]
RUN ["/opt/sdk-tools/android-accept-licenses.sh", "android update sdk --filter \"extra-google-google_play_services\" --no-ui --force -a"]
