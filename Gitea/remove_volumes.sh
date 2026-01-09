#!/bin/bash

sudo chown -R owner:owner gitea-data
rm -rf gitea-data

sudo chown -R owner:owner mysql-data
rm -rf mysql-data
