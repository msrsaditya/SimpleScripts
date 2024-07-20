#!/bin/bash

# A Simple Script to Get the Name of a Person Using their Phone Number, Requires 'node' and 'truecallerjs' NPM Library

truecallerjs -s "+91$1" | grep -w 'name' | awk -F ': ' '{print $2}'
