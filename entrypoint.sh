#!/bin/bash

# Launch shinyproxy with the trusted keystore containing CCAO public cert
java \
  -Djavax.net.ssl.trustStore=/run/secrets/DC_CERT \
  -Djavax.net.ssl.trustStorePassword=${JAVA_TRUST_STORE_PASSWORD} \
  -jar ${WORKDIR}/shinyproxy.jar
