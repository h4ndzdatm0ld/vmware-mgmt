#!/bin/bash

cd ~/.ssh/
ssh-keygen -t rsa -f id_rsa -q -P ""
ssh-keygen -A
