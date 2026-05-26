#!/usr/bin/env bash
if [[ -n "$KEEPASS_SECRET_KEYFILE" && -n "$KEEPASS_SECRET_DB" ]]; then
    keepassxc --keyfile "$KEEPASS_SECRET_KEYFILE" "$KEEPASS_SECRET_DB"
else
    keepassxc
fi

