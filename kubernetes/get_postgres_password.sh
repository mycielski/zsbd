#!/bin/sh

kubectl get secret postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode
