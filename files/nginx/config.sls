#!py

import salt

class Config():
	
    states = {}

    # is this distro specific? debian / ubuntu for now
    conf_dir = '/etc/nginx/'
        
    defaults = {
        'file_octal': 644,
        'dir_octal': 755,
        'template': 'jinja',
    }

    file_managed_defaults = [
        {'user': 'root'},
        {'group': 'root'},
        {'makedirs': True}
    ]
        
    def __init__(self, pillar):
        self.pillar = pillar
        self.webroot_base = pillar['webroot_base']
        self.websites = pillar['websites']
        self.http_port = 8080 if pillar['varnish'] else 80
        self.cluster = pillar['cluster'] if pillar['cluster'] else False

    def web(self):
        dir_options = [
            {'mode': self.defaults['dir_octal']}
        ]
    
        file_options = [
            {'mode': self.defaults['file_octal']}
        ]

        dir_options += self.file_managed_defaults
        file_options += self.file_managed_defaults
        vhost_options = file_options + [
            {'source': 'salt://nginx/templates/vhost'},
            {'template': self.defaults['template']}
        ]
    
        for website, data in self.websites.iteritems():
            cms = data['cms']['type'] if data['cms'] else False
            cms_plugins = data['cms']['plugins'] if data['cms'] else []
            sub_dir = data['sub_dir'] if 'sub_dir' in data else ''

            vhost_options = [
                {'source': 'salt://nginx/templates/vhost'},
                {'template': self.defaults['template']},
                {'mode': self.defaults['file_octal']},
                {'user': 'root'},
                {'group': 'root'},
                {'makedirs': True},
                {'context': {
                    'cluster': self.cluster,
                    'server_name': website,
                    'aliases': data['aliases'],
                    'ssl': data['ssl'],
                    'cms': cms,
                    'cms_plugins': cms_plugins,
                    'http_port': self.http_port,
                    'sub_dir': sub_dir,
                }}
            ]

            webroot_dir_options = [
                {'user': 'www-data'},
                {'group': 'www-data'},
                {'mode': 755}
            ]
            self.states[self.webroot_base + website] = {'file.directory': webroot_dir_options}
            self.states[self.conf_dir + 'sites-available/' + website] = {'file.managed': vhost_options}
            self.states[self.conf_dir + 'sites-enabled/' + website] = {
                'file.symlink': [
                    {'target': self.conf_dir + 'sites-available/' + website},
                    {'user': 'root'},
                    {'group': 'root'},
                ]
            }

    def nginx(self):
        options = [
            {'user': 'root'},
            {'group': 'root'},
            {'mode': 644},
            {'makedirs': True}
        ]

        self.states['rm_default_vhost'] = {
            'cmd.run': [
                {'name': 'rm -f /etc/nginx/sites-available/default; rm -f /etc/nginx/sites-enabled/default'}
            ]
        }

        # W3TC-specific includes
        for file in ['browser', 'page_cache', 'page_cache_core']:
            w3tc_file_options = options + [{'source': 'salt://nginx/templates/w3tc/{0}.inc'.format(file)}]

            self.states[self.conf_dir + 'conf.d/w3tc/' + file + '.inc'] = {'file.managed': w3tc_file_options}
            
        # General includes
        for file in ['security']:
            security_file_options = options + [{'source': 'salt://nginx/templates/extras/{0}.inc'.format(file)}]
            self.states[self.conf_dir + 'conf.d/security.inc'] = {'file.managed': security_file_options}

        main_nginx_file_options = options + [{'source': 'salt://nginx/templates/nginx.conf'}]
        self.states[self.conf_dir + 'nginx.conf'] = {'file.managed': main_nginx_file_options}

        
def run():
    config = Config(__pillar__)
    config.nginx()
    config.web()

    return config.states
