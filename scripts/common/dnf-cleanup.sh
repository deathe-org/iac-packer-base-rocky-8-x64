#!/bin/bash -e

/bin/echo '--> Cleaning up package manager.'
/bin/dnf clean all

/bin/echo '---> Clear DNF history.'
/bin/rm -rf /var/lib/dnf/history*
