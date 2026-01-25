#!/bin/bash

cd terraform_edge/ && terraform destroy -auto-approve \
&& cd ../terraform_bigdata_cluster && terraform destroy -auto-approve
