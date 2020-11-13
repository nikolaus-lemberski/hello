#!/bin/bash

## Create Serviceaccount
# kubectl create sa github
# kubectl create clusterrolebinding github-sa-binding --clusterrole cluster-admin --serviceaccount=default:github

## Add values, get from 'kubectl config view'
server=
cluster=
serviceaccount=

name=$(kubectl get sa $serviceaccount -o jsonpath='{.secrets[0].name}')
ca=$(kubectl get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$name -o jsonpath='{.data.namespace}' | base64 --decode)

echo "apiVersion: v1
kind: Config
clusters:
- name: ${cluster}
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: nlemberski-aws-tas
    namespace: default
    user: $serviceaccount
current-context: default-context
users:
- name: $serviceaccount
  user:
    token: ${token}
" > serviceaccount.yml
