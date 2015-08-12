include:
    - memcached.config

memcached:
    pkg:
        - installed
    service.running:
        - require:
            - pkg: memcached
            - sls: memcached.config
        - watch:
            - file: /etc/memcached.conf
