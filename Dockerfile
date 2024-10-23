FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt update && apt install -y software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt update \
    && apt install -y \
    nginx \
    php8.2-fpm \
    php8.2-mysql \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Add your static assets to the web directory
COPY web /var/www/html

# Configure Nginx to process PHP files
RUN echo "server { \
    listen 80; \
    root /var/www/html; \
    index index.php index.html; \
    location / { \
        try_files \$uri \$uri/ =404; \
    } \
    location ~ \.php$ { \
        include snippets/fastcgi-php.conf; \
        fastcgi_pass unix:/run/php/php8.2-fpm.sock; \
    } \
    location ~ /\.ht { \
        deny all; \
    } \
}" > /etc/nginx/sites-available/default

# Expose port 80 for the web server
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "service php8.2-fpm start && nginx -g 'daemon off;'"]
