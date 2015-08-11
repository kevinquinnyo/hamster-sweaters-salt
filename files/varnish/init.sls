include:
    - varnish.config

varnish:
    pkg:
        - installed
    service.running:
        - require:
            - pkg: varnish
            - sls: varnish.config
