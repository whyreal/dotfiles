#!/usr/bin/env python3

from joplin_api import JoplinApiSync
joplin = JoplinApiSync(token='a083d7a049c9c3dbc4a76ae6c45043e1bb966cc705539dfbb4af6b6e407ad270c640a4fcd792717220f99d6994d889788d6e18226eaae1e9c980b4a1133ad78e')

import sys

action = sys.argv[1]
id = sys.argv[2]

if action == "edit":
    note_file = open("/Users/Real/.config/joplin-desktop/edit-" + id + ".md", "w")
    note = joplin.get_note(id).json()
    note_file.writelines([note["title"], "\n\n"])
    note_file.write(note["body"])

if action == "update":
    note_file = open("/Users/Real/.config/joplin-desktop/edit-" + id + ".md", "r")
    note = joplin.get_note(id).json()

    lines = note_file.readlines()
    note["body"] = "".join(lines[2:])
    note["note_id"] = id
    note["title"] = lines[0].strip()

    joplin.update_note(**note)

if action == "update":
    # TODO: delete file
    pass
