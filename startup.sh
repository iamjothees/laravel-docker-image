#!/bin/bash
service apache2 start

if [ -n "$MY_COMMANDS" ]; then
  eval "$MY_COMMANDS"
fi

tail -f /dev/null