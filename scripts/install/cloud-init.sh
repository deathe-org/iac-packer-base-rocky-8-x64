#!/bin/bash -e

/bin/echo '--> Install cloud-init.'
/bin/dnf --debuglevel=1 -y install \
  cloud-init
