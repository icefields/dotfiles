#!/bin/bash

swayidle -w \
    timeout 300 'swaylock -f' \
    before-sleep 'swaylock -f'

