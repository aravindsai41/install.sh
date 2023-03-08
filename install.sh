#!/bin/bash

# Generate a random username and password
username=$(openssl rand -hex 8)
password=$(openssl rand -hex 12)

# Install dependencies
apt-get update
apt-get -y install curl git build-essential libssl-dev libffi-dev python3-dev python3-pip postgresql postgresql-contrib

# Set up PostgreSQL database
sudo -u postgres psql -c "CREATE DATABASE open_source_billing;"
sudo -u postgres psql -c "CREATE USER $username WITH PASSWORD '$password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE open_source_billing TO $username;"

# Install open-source-billing
cd /opt
git clone https://github.com/vteams/open-source-billing.git
cd open-source-billing
pip3 install -r requirements.txt

# Configure the application
cp config.py.sample config.py
sed -i "s/DB_USER = ''/DB_USER = '$username'/" config.py
sed -i "s/DB_PASSWORD = ''/DB_PASSWORD = '$password'/" config.py
sed -i "s/DB_NAME = ''/DB_NAME = 'open_source_billing'/" config.py

# Start the application
python3 app.py
