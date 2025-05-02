#!/bin/bash

dropdb -U kiarash-sanei -h localhost -p 5432 Student.Association
createdb -U kiarash-sanei Student.Association
psql -U "kiarash-sanei" -d Student.Association -f Student.Association.sql
psql -U "kiarash-sanei" -d Student.Association -c "\dt"