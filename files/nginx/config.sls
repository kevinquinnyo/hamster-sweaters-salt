#!py

import salt

class Config():
	
    states = {}

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

    def build_dirs(self):
        options = [
            {'mode': self.defaults['dir_octal']}
        ]

        options += self.file_managed_defaults
    
        for website in self.websites:
            self.states[self.webroot_base + website] = { 'file.directory': [options] }

def run():
    config = Config(__pillar__)
    config.build_dirs()

    return config.states
