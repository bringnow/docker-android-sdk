FROM ubuntu:14.04
MAINTAINER Fabian Köster <fabian.koester@bringnow.com>

ENV DEBIAN_FRONTEND noninteractive

# The file .dockercacheupdated is compared by docker to the last one
# in order to decide if the cache needs to be invalidated. If you want to
# force docker to update the cache, execute
# "date -R > .docker_cache_last_updated"
ADD .docker_cache_last_updated /

# Update package list
RUN apt-get update

# Update packages
RUN apt-get upgrade -y

# Install required packages 
RUN apt-get install -y openjdk-7-jdk unzip zip ant wget

# add 32-bit libraries needed for Android Tools (adb, aapt)
RUN apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1

ENV ANDROID_SDK_VERSION 24.3.3
ENV ANDROID_HOME /opt/android-sdk-linux

# Install Android SDK installer
RUN wget -nv http://dl.google.com/android/android-sdk_r${ANDROID_SDK_VERSION}-linux.tgz &&\
  tar xf android-sdk*.tgz -C /opt &&\
  rm android-sdk*.tgz

# Install Android SDK components

ENV ANDROID_COMPONENTS build-tools-22.0.1,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository,android-19,addon-google_apis-google-19,android-22,addon-google_apis-google-22
RUN echo "y" | ${ANDROID_HOME}/tools/android update sdk --no-ui --all --filter $ANDROID_COMPONENTS
