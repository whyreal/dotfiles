#!/bin/bash

# download plantuml.jar
# config g:plantuml_executable_script in vimrc

dir=`dirname $@`

plantuml -gui "$dir" 2>&1 > /dev/null & 
#java -jar plantuml -tsvg $@

