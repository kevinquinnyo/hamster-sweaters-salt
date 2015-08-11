/etc/php5/fpm/php-fpm.conf:
    file.managed:
        - source: salt://php-fpm/templates/php5-fpm.conf
        - mode: 644
        - user: root
        - group: root
        - makedirs: True
