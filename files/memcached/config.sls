#!py
import math

def config():
    states = {}

    # give memcached 25% of memory
    malloc = math.floor(__grains__['mem_total'] / 4)

    # Ubuntu package creates memcache user, debian can use nobody - needs investigation
    if __grains__['os'] == 'Debian':
        user = 'nobody'
    else:
        user = 'memcache'

    states['/etc/memcached.conf'] = {
        'file.managed': [
            {'source': 'salt://memcached/templates/memcached.conf'},
            {'user': 'root'},
            {'group': 'root'},
            {'mode': 644},
            {'template': 'jinja'},
            {'context': { 
                'malloc': malloc,
                'user': user
            }}
        ]
    }
    return states

def run():
    return config()
