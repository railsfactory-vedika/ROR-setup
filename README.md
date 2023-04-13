# Folder structure
- `appdb`     : ROR applicatioon code
- `files`     : DB files to be copied to database and ROR machine
- `terraform` : IAC to create 2 EC2 instance


# [DB machine] Switch to postgres user and create db and user
- cd to /home/ubuntu/workspace/files/
- chmod +x db.sh
- db.sh
- sudo su - postgres
- createuser -s -P appdb
- createdb postgresql -O appdb

# [ROR server tasks]
- cd /home/ubuntu/workspace/files/
- chmod +x app.sh
- Run shell script with argument to install required gem `./app.sh gem_install`
- Run shell script with argument to reconfigure creds `./app.sh reconfigure_credentials`
- rails new appdb -d=postgresql
- cd worrkspace/appdb/
- make entry of db in `database.yml` file
  ```
  default: &default
    adapter: postgresql
    encoding: unicode
    # For details on connection pooling, see Rails configuration guide
    # https://guides.rubyonrails.org/configuring.html#database-pooling
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    host: ec2-ip-address
    username: userdb
    password: ******
  ```
- Run shell script with argument to configure database `./app.sh configure_db`
- rails console
- User.create(name: 'John Doe', email: 'john@example.com')
- Run shell script with argument to configure routes   `./app.sh routes_configure`
- cd workspace/appdb
- rails server -b 0.0.0.0 