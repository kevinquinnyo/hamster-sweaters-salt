#!py

def config(states):
    certs = []
    public_ip = __grains__['fqdn_ip4'][0]
    webroot_base = __pillar__['webroot_base'].rstrip("/")

    # figure out if cert is defined or we default to the self-signed cert
    for website, data in __pillar__['websites'].iteritems():
        if 'ssl' in data and data['ssl']:
            pem_path = '/etc/nginx/ssl/{0}.pem'.format(website)
            certs.append(pem_path)

    states['/etc/pound/pound.cfg'] = {
        'file.managed': [
            {'user': 'root'},
            {'group': 'root'},
            {'mode': 644},
            {'makedirs': True},
            {'template': 'jinja'},
            {'source': 'salt://pound/templates/pound.cfg'},
            {'context': {
                'certs': certs,
                'public_ip': public_ip
            }},
        ]
    }

    states['/etc/default/pound'] = {
        'file.managed': [
            {'user': 'root'},
            {'group': 'root'},
            {'mode': 644},
            {'makedirs': True},
            {'template': 'jinja'},
            {'source': 'salt://pound/templates/default'}
        ]
    }
    return states

def run():
    states = {}
    states = config(states)
    return states

