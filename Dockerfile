FROM ubuntu:latest

LABEL maintainer="docker@gavinharrison.me.uk"
LABEL version="1.0"
LABEL description="This is a docker image for a local angular cli development enviroment."

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade 
RUN apt install -y nodejs npm && npm -v

RUN npm install --unsafe-perm -g @angular/cli && ng v

COPY src/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /project/
EXPOSE 4200

ENTRYPOINT [ "/docker-entrypoint.sh" ]