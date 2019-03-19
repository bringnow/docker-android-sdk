# Inspired from https://github.com/heikomaass/docker-android/blob/master/android-sdk/Dockerfile
FROM node:8

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ANDROID_HOME /opt/android-sdk-linux

RUN dpkg --add-architecture i386 \
  && apt-get update && apt-get install -y --no-install-recommends openjdk-8-jdk-headless \
    expect \
    libncurses5:i386 \
    libstdc++6:i386 \
    zlib1g:i386 \
    build-essential \
    openssh-client \
  && apt-get install -y --no-install-recommends maven \
  && rm -rf /var/lib/apt/lists/*

# Install Android SDK installer
ARG ANDROID_SDK_VERSION=4333796
ARG ANDROID_SDK_SHA256=92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
RUN curl -o android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
  && echo "${ANDROID_SDK_SHA256} android-sdk.zip" | sha256sum -c \
  && mkdir - ${ANDROID_HOME} \
  && unzip -q -d ${ANDROID_HOME} android-sdk.zip \
  && rm *.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin

# Install Android SDK components
RUN mkdir /root/.android \
  && touch /root/.android/repositories.cfg \
  && sdkmanager "tools" \
		"platform-tools" \
		"build-tools;27.0.3" \
		"platforms;android-27" \
		"add-ons;addon-google_apis-google-24" \
		"extras;android;m2repository" \
		"extras;google;google_play_services" \
		"patcher;v4" \
  && yes | sdkmanager --licenses
