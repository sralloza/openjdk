FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless firefox-geckodriver && \
    apt-get clean;
