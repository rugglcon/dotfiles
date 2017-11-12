#!/usr/bin/python3
""" script to run after wal """

import json
from os import environ
from subprocess import call

with open(environ['HOME'] + '/.cache/wal/colors.json') as dfile:
    wal_info = json.load(dfile)

call(["gsettings", "set", "org.gnome.desktop.background",\
        "picture-uri", "file://" + wal_info["wallpaper"]])

with open(environ['HOME'] + '/.cache/wal/colors.sh') as colors:
    vim_f = open(environ['HOME'] + '/.cache/wal/colors.vim', 'w')
    for line in colors:
        ind = line.find('#')
        if ind != -1 and ind != 0:
            vim_f.write('let g:' + line)

vim_f.close()
colors.close()
