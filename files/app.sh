#!/bin/bash
# Export path
if [ $# -ne 1 ]
then
echo "Run script like this to install gem    ./app.sh gem_install"
echo "Run script like this to install gem    ./app.sh reconfigure_credentials"
echo "Run script like this to install gem    ./app.sh configure_db" 
echo "Run script like this to install routes ./app.sh routes_configure"
fi

input=$1
routes=$$1
app_workdir=/home/ubuntu/ved-workspace/appdb/
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
if [ "$input" == "gem_install" ]
then
cd $app_workdir
gem install --file Gemfile
fi

# Configure creds
if [ "$input" == "reconfigure_credentials" ]
then
cd $app_workdir/config
rm -rf credentials.yml.enc
cd $app_workdir
EDITOR="nano" bin/rails credentials:edit
fi

if [ "$input" == "configure_db" ]
then
cd $app_workdir
echo "configure database"
rails db:create
echo "generating tables"
rails generate model User name:string email:string
rails db:migrate
echo "logging into rails console and create some sample user"
fi

# Configure routes
if [ "$input" == "routes_configure" ]
then
mkdir -p $app_workdir/app/views/users
cp index.html.erb $app_workdir/app/views/users/
cp users_controller.rb $app_workdir/app/controllers/
cp routes.rb $app_workdir/config/routes.rb
fi