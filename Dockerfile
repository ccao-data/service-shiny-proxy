FROM openjdk:8-jre

LABEL maintainer "Dan Snow <dsnow@cookcountyassessor.com>"

RUN mkdir -p /opt/shinyproxy/
RUN wget https://www.shinyproxy.io/downloads/shinyproxy-2.3.0.jar -O /opt/shinyproxy/shinyproxy.jar
COPY application.yml /opt/shinyproxy/application.yml

ARG DATA_LOCATION
RUN sed -i 's#DATA_LOCATION#'"$DATA_LOCATION"'#' /opt/shinyproxy/application.yml

WORKDIR /opt/shinyproxy/
CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
