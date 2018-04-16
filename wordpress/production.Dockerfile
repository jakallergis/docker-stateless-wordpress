FROM wordpress:4.9-fpm
MAINTAINER John A. Kallergis <j.a.kallergis@gmail.com>

# Overwrite Wordpress content with ours
RUN rm -rf /usr/src/wordpress/wp-content;
COPY src/wp-content /usr/src/wordpress/wp-content

# .htaccess configuration
COPY src/.htaccess /var/www/html/.htaccess

# PHP configuration
COPY php/php.prod.ini /usr/local/etc/php/conf.d/php.ini

# Fix ownership of baked source
RUN chown -R www-data:www-data /usr/src/wordpress;