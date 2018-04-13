#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import jinja2
import json
import sys

tpl = sys.argv[1]
data = json.load(open(sys.argv[2]))

tpl_loader = jinja2.FileSystemLoader(searchpath="./")
tpl_env = jinja2.Environment(loader=tpl_loader, trim_blocks=True, lstrip_blocks=True)

template = tpl_env.get_template(tpl)
print(template.render(data))
