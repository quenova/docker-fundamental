FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y nginx

ENTRYPOINT [ "/bin/bash", "-c", "service nginx start && exec /bin/bash" ]