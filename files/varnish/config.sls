#!py

def run():
    config = Config(__pillar__)

    config.do_something()

    return config.states
