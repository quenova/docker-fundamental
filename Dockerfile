FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Update dan install packages yang diperlukan
RUN apt update && apt install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt update \
    && apt install -y \
    nginx \
    php8.2-fpm \
    php8.2-mysql \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Tambahkan folder web Anda ke direktori Nginx
COPY web /var/www/html

# Copy file konfigurasi Nginx
COPY config/nginx.conf /etc/nginx/sites-available/default

# Pastikan symlink untuk sites-enabled Nginx
RUN rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Expose port 80 untuk Nginx
EXPOSE 80

# Start PHP-FPM dan Nginx
CMD ["sh", "-c", "service php8.2-fpm start && nginx -g 'daemon off;'"]
