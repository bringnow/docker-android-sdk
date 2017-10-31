# Inspired from https://github.com/heikomaass/docker-android/blob/master/android-sdk/Dockerfile
FROM node:6
MAINTAINER Fabian Köster <fabian.koester@bringnow.com>

ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_HOME /opt/android-sdk-linux

RUN bash -c "echo deb http://ftp.debian.org/debian jessie-backports main >> /etc/apt/sources.list" \
  && dpkg --add-architecture i386 \
  && apt-get update && apt-get install -t jessie-backports -y --no-install-recommends openjdk-8-jdk-headless \
    expect \
    libncurses5:i386 \
    libstdc++6:i386 \
    zlib1g:i386 \
    build-essential \
    openssh-client \
  && apt-get install -y --no-install-recommends maven \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK installer
ARG ANDROID_SDK_VERSION=24.4.1
ARG ANDROID_SDK_SHA256=e16917ad685c1563ccbc5dd782930ee1a700a1b6a6fd3e44b83ac694650435e9
RUN curl -o android-sdk.tar.gz http://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz \
  && echo "${ANDROID_SDK_SHA256} android-sdk.tar.gz" | sha256sum -c \
  && tar -x -C /opt -f android-sdk.tar.gz \
  && rm *.tar.gz

COPY tools /opt/sdk-tools

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/sdk-tools

# Install Android SDK components
RUN /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter tools --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter platform-tools --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-23.0.1\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-23.0.2\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-23.0.3\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-24.0.0\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-24.0.1\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-24.0.2\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-24.0.3\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-25.0.0\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-25.0.1\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-25.0.2\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-26.0.0\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-26.0.1\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-26.1.0\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"build-tools-27.0.0\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"extra-android-support\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-22\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-23\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-24\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-25\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-26\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"android-27\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"addon-google_apis-google-23\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"addon-google_apis-google-24\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"addon-google_apis-google-25\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"addon-google_apis-google-26\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"addon-google_apis-google-27\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"extra-android-m2repository\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"extra-google-m2repository\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --filter \"extra-google-google_play_services\" --no-ui --force -a" \
  && /opt/sdk-tools/android-accept-licenses.sh "android update sdk --no-ui --force -a"
