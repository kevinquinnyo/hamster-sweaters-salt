include:
    - php-fpm.config

php5-fpm:
    pkg:
        - installed
    service.running:
        - require:
            - pkg: php5-fpm
            - sls: php-fpm.config
        - watch:
            - file: /etc/php5/fpm/php-fpm.conf
