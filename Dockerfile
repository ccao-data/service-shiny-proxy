# Minimal dockerfile for running shinyproxy JAR
FROM openjdk:8-jre

# Set working directory for the entire application
ENV WORKDIR=/opt/shinyproxy
WORKDIR ${WORKDIR}
ENTRYPOINT "${WORKDIR}/entrypoint.sh"

# Download the shinyproxy JAR file
RUN wget --no-verbose https://github.com/openanalytics/shinyproxy/releases/download/v3.0.2/shinyproxy-3.0.2-exec.jar -O ${WORKDIR}/shinyproxy.jar

# Copy app code into the working dir
COPY . ${WORKDIR}


### LABELLING ###

# Build arguments used to label the container, these variables are predefined
# as part of GitLab. They get passed to the container as build-args in the
# .gitlab-ci.yml file. These arguments only exist when building the container
ARG VCS_NAME
ARG VCS_URL
ARG VCS_REF
ARG VCS_REF_SHORT
ARG VCS_VER
ARG VCS_ID
ARG VCS_NAMESPACE

# Environmental variables that are passed to the container. These variables
# exist inside each app and can be called from R. They are used to create a
# version number in the application UI as well as link to the GitLab
# Service Desk
ENV VCS_NAME=$VCS_NAME
ENV VCS_URL=$VCS_URL
ENV VCS_REF=$VCS_REF
ENV VCS_REF_SHORT=$VCS_REF_SHORT
ENV VCS_VER=$VCS_VER
ENV VCS_ID=$VCS_ID
ENV VCS_NAMESPACE=$VCS_NAMESPACE

# Create labels for the container. These are standardized labels defined by
# label-schema.org. Many applications look for these labels in order to display
# information about a container
LABEL maintainer "Dan Snow <daniel.snow@cookcountyil.gov>"
LABEL com.centurylinklabs.watchtower.enable="true"
LABEL org.opencontainers.image.title=$VCS_NAME
LABEL org.opencontainers.image.source=$VCS_URL
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VCS_VER
