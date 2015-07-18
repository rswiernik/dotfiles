#!/bin/bash

pwd | awk -F'[/]' '{print $6}'
if [[ $? -eq 0 ]]; then
	cp ./.* ./* ~/
fi
