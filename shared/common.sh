#!/bin/bash

# some common functions to cut down on repeated code

error_trig() {
	printf "%s\n" "$1" 1>&2
	exit 1
}

file_check() {
	if [[ ! -f "$(readlink -f $1)" ]]; then
		error_trig "combine_pdf: cannot stat '$1'"
	fi
}
