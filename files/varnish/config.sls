#!py
import math

class Config:

    states = {}

    conf_dir = '/etc/varnish/'

    defaults = {
        'file_octal': 644,
        'dir_octal': 755,
        'template': 'jinja',
    }

    file_managed_defaults = [
        {'user': 'root'},
        {'group': 'root'},
        {'makedirs': True},
    ]

    def __init__(self, pillar, grains):
        self.pillar = pillar
        self.grains = pillar
        self.malloc = math.floor(grains['mem_total'] / 4)
        # Make varnish confgurable per vhost
        self.vcl = 'wordpress.vcl'

    def setup(self):

        options = self.file_managed_defaults + [{'mode': self.defaults['file_octal']}]

        vcl_file_opts = options + [
            {'source': 'salt://varnish/templates/{0}'.format(self.vcl)}
        ] 
        vcl_daemon_file_opts = options + [
            {'source': 'salt://varnish/templates/daemon'},
            {'template': self.defaults['template']},
            {'context': {'malloc': self.malloc}}
        ]
        
        self.states[self.conf_dir + 'default.vcl'] = {'file.managed': vcl_file_opts}
        self.states['/etc/default/varnish'] = {'file.managed': vcl_daemon_file_opts}


def run():
    config = Config(__pillar__, __grains__)
    config.setup()

    return config.states
