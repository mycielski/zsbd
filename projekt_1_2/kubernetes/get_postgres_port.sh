#!/bin/sh

kubectl get svc postgres-external | grep -Eo "5432:[0-9]+" | awk -F ':' '{ print $2 }'
