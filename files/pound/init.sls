include:
    - pound.config

pound:
    pkg:
        - installed
    service.running:
        - require:
            - pkg: pound
            - sls: pound.config
        - watch:
            - file: /etc/pound/pound.cfg

