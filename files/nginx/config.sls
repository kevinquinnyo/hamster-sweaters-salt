#!py

import salt

class Config():
	
    states = {}

    conf_dir = '/etc/nginx/'
        
    file_defaults = [
        {'user': 'root'},
        {'group': 'root'},
        {'mode': 644},
        {'makedirs': True},
        {'template': 'jinja'}
    ]

    dir_defaults = [
        {'user': 'root'},
        {'group': 'root'},
        {'mode': 755},
        {'makedirs': True}
    ]

    webdir_defaults = [
        {'user': 'www-data'},
        {'group': 'www-data'},
        {'mode': 755},
        {'makedirs': True}
    ]
        
    def __init__(self, pillar, grains):
        self.pillar = pillar
        self.grains = grains
        self.webroot_base = pillar['webroot_base']
        self.websites = pillar['websites']
        self.http_port = 8080 if pillar['varnish'] else 80
        self.cluster = pillar['cluster'] if pillar['cluster'] else False
        self.hhvm = pillar['hhvm']

    def web(self):
        for website, data in self.websites.iteritems():
            vhost_options = self.build_vhost(website, data)
            self.states[self.webroot_base + website] = {'file.directory': [self.webdir_defaults]}
            self.states[self.conf_dir + 'sites-available/' + website] = {'file.managed': vhost_options}
            self.states[self.conf_dir + 'sites-enabled/' + website] = {
                'file.symlink': [
                    {'target': self.conf_dir + 'sites-available/' + website},
                    {'user': 'root'},
                    {'group': 'root'},
                ]
            }

    def build_vhost(self, website, data):
        cms = data['cms']['type'] if data['cms'] else False
        cms_plugins = data['cms']['plugins'] if data['cms'] else []
        sub_dir = data['sub_dir'] if 'sub_dir' in data else ''

        vhost_options = self.file_defaults + [
            {'source': 'salt://nginx/templates/vhost'},
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
        return vhost_options

    def nginx(self):

        # is there an inverse of file.managed to ensure /etc/nginx/sites-{enabled,available}/default does not exist?
        self.states['rm_default_vhost'] = {
            'cmd.run': [
                {'name': 'rm -f /etc/nginx/sites-available/default; rm -f /etc/nginx/sites-enabled/default'}
            ]
        }

        # W3TC-specific includes
        for file in ['browser', 'page_cache', 'page_cache_core']:
            w3tc_file_options = self.file_defaults + [{'source': 'salt://nginx/templates/w3tc/{0}.inc'.format(file)}]
            self.states[self.conf_dir + 'conf.d/w3tc/' + file + '.inc'] = {'file.managed': w3tc_file_options}

        # General includes
        for file in ['security']:
            security_file_options = self.file_defaults + [{'source': 'salt://nginx/templates/extras/{0}.inc'.format(file)}]
            self.states[self.conf_dir + 'conf.d/security.inc'] = {'file.managed': security_file_options}

        main_nginx_file_options = self.file_defaults + [
            {'source': 'salt://nginx/templates/nginx.conf'},
            {'context': {'hhvm': self.hhvm}}
        ]
        self.states[self.conf_dir + 'nginx.conf'] = {'file.managed': main_nginx_file_options}

        # ubuntu package includes this by default, debian, annoyingly does not
        if self.grains['os'] == 'Debian':
            line = 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;'
            self.states[self.conf_dir + 'fastcgi_params'] = {
                'file.append': [{'text': line}]
            }
        
def run():
    config = Config(__pillar__, __grains__)
    config.nginx()
    config.web()

    return config.states
