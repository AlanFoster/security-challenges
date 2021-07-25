FROM kong:2.1.4-alpine

# Install curl for configuring the services
USER root
RUN apk update && apk add curl

USER kong
COPY ./ ./
