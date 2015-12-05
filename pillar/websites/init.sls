cluster: False
varnish: True
hhvm: False
webroot_base: '/var/www/'

websites:
    000000-default:
        aliases: []
        ssl: False
        cms: False
    hamster-sweaters.com:
        aliases:
            - www.hamster-sweaters.com
        ssl: True
        cms: False
        sub_dir: '_site'
    kevops.com:
        aliases:
            - www.kevops.com
        ssl: False
        cms: 
            type: 'wordpress'
            plugins:
                - w3tc
