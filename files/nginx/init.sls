include:
    - nginx.config

nginx:
    pkg:
        - installed
    service.running:
        - require:
            - pkg: nginx
            - sls: nginx.config
        - watch:
            - file: /etc/nginx/nginx.conf

# Inert state can be used elsewhere to reload nginx
nginx-reload:
    module.wait:
        - name: service.reload
        - m_name: nginx
