# Minimal dockerfile for running shinyproxy JAR
FROM openjdk:8-jre

# Build arguments used to label the container
ARG BUILD_DATE
ARG VCS_NAME
ARG VCS_URL
ARG VCS_REF
ARG VCS_VER
ARG VCS_REF_SHORT

# Build arguments that appear in the app as version and commit number
ENV VCS_VER $VCS_VER
ENV VCS_REF_SHORT $VCS_REF_SHORT

# Create labels for the container
LABEL maintainer "Dan Snow <dsnow@cookcountyassessor.com>" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$VCS_NAME \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version=$VCS_VER \
      org.label-schema.schema-version="1.0.0-rc1"

RUN mkdir -p /opt/shinyproxy/
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-2.3.0.jar -O /opt/shinyproxy/shinyproxy.jar
COPY application.yml /opt/shinyproxy/application.yml
COPY favicon.png /opt/shinyproxy/favicon.png

WORKDIR /opt/shinyproxy/
CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
