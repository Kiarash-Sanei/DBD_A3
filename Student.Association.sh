#!/bin/bash

psql -U "kiarash-sanei" -d Student.Association -f Student.Association.sql
psql -U "kiarash-sanei" -d Student.Association -c "\dt"