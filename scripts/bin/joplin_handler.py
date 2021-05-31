#!/usr/bin/env python3

from joplin_api import JoplinApiSync
import sys
import os

joplin = JoplinApiSync(token='a083d7a049c9c3dbc4a76ae6c45043e1bb966cc705539dfbb4af6b6e407ad270c640a4fcd792717220f99d6994d889788d6e18226eaae1e9c980b4a1133ad78e')
HOME = os.environ.get("HOME")

action = sys.argv[1]
id = sys.argv[2]

JFile = HOME + "/.config/joplin-desktop/edit-" + id + ".md"

if action == "edit":
    note_file = open(JFile, "w")
    note = joplin.get_note(id).json()
    note_file.writelines([note["title"], "\n\n"])
    note_file.write(note["body"])

if action == "update":
    note_file = open(JFile, "r")
    note = joplin.get_note(id).json()

    lines = note_file.readlines()
    note["body"] = "".join(lines[2:])
    note["note_id"] = id
    note["title"] = lines[0].strip()

    joplin.update_note(**note)

if action == "delete":
    if os.path.exists(JFile):
        os.remove(JFile)
