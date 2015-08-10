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

    def web(self):
        dir_options = [
            {'mode': self.defaults['dir_octal']}
        ]
    
        file_options = [
            {'mode': self.defaults['file_octal']}
        ]

        dir_options += self.file_managed_defaults
        file_options += self.file_managed_defaults
    
        # just a temporary hack -- we need this dir and at least one file here for now    
        self.states[self.conf_dir + 'conf.d/empty'] = {'file.managed': [file_options]}

        for website in self.websites:
            self.states[self.webroot_base + website] = {'file.directory': [dir_options]}
            self.states[self.conf_dir + 'sites-available/' + website] = {'file.managed': [file_options]}
            self.states[self.conf_dir + 'sites-enabled/' + website] = {
                'file.symlink': [
                    {'target': self.conf_dir + 'sites-available/' + website},
                    {'user': 'root'},
                    {'group': 'root'},
                ]
            }

    def nginx(self):
        options = [
            {'mode': self.defaults['dir_octal']}
        ]

        nginx_dirs = [
            'conf.d',
            'sites-available',
            'sites-enabled',
        ]

        options += self.file_managed_defaults

        for dir in nginx_dirs:
            self.states[self.conf_dir + dir] = {'file.directory': [options]}
    
        self.states['rm_default_vhost'] = {
            'cmd.run': [
                {'name': 'rm -f /etc/nginx/sites-available/default; unlink /etc/nginx/sites-enabled/default; true'}
            ]
        }
        
def run():
    config = Config(__pillar__)
    config.nginx()
    config.web()

    return config.states
