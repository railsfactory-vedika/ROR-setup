#!/bin/bash
# Copy db files
echo "coping config files"
sudo cp postgresql.conf /etc/postgresql/14/main/postgresql.conf
sudo cp pg_hba.conf /etc/postgresql/14/main/pg_hba.conf
echo "coping config files completed"
# Restart service
echo "restarting postgres service"
sudo /etc/init.d/postgresql restart