#!/bin/sh
docker stop $(docker ps -aq) && sudo systemctl restart NetworkManager docker
