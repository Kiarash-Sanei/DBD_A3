#!/bin/bash

dropdb -U kiarash-sanei -h localhost -p 5432 Football.Federation
createdb -U kiarash-sanei Football.Federation
psql -U "kiarash-sanei" -d Football.Federation -f Football.Federation.sql
psql -U "kiarash-sanei" -d Football.Federation -c "\dt"