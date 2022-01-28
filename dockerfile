FROM php:8.0.5
RUN apt-get update -y && apt-get install -y --no-install-recommends openssh-server zip unzip git libonig-dev ssh
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo mbstring && echo "root:Docker!" | chpasswd 

# configure startup
COPY sshd_config /etc/ssh/
COPY startup.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/startup.sh

# Copy and configure the ssh_setup file
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp
# RUN chmod +x /tmp/ssh_setup.sh \
#     && sleep 1 && ./tmp/ssh_setup.sh


WORKDIR /app
COPY . /app
RUN composer install

# for some reason the script inside composer.json are not getting triggered !
RUN cp -n .env.example .env && php artisan key:generate

# Open port 2222 for SSH access
EXPOSE 2222 80 

ENTRYPOINT [ "startup.sh" ]
