FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y nginx

#add asset to webdir
COPY web /var/www/html

ENTRYPOINT [ "/bin/bash", "-c", "service nginx start && exec /bin/bash" ]