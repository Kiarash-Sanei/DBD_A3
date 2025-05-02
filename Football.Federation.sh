#!/bin/bash

psql -U "kiarash-sanei" -d Football.Federation -f Football.Federation.sql
psql -U "kiarash-sanei" -d Football.Federation -c "\dt"