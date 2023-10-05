# Setup for the Application

This README would normally document whatever steps are necessary to get the
application up and running.

The steps need to be followed

The versions required are

* Ruby version 3.2.1
* Rails version 6.1.7.3
* PostgreSQL version 14.8
* node version v16.20.0
* yarn version 1.22.19
* elastic search version 7.17.11
* redis-server version 6.0.16

##

### Instalation guide

For elastic search installation follow this guide

[Elasticsearch Installation](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-elasticsearch-on-ubuntu-18-04)

For installation of Redis server

[Redis server Instalation](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04)

##

### Steps for running the application
  
The correct versions of the above-mentioned software should be installed on your local system for running the application.

#### After all the software is installed the following steps are to be performed 

#### 1. To install all the dependencies and gem run the following command
``` bash
bundle install && yarn install
```
#### 2. To set up the database (create a database, migrate and seed the database) run the following command

```ruby
rails db:setup
```

#### 3. Make sure that the elastic-search is running on the system at ```localhost:9200```

#### 4. Then run the rails server by the following command

```ruby
rails s
```

#### 5. Then run to run the cron job for scheduling the notification run the following command

```bash
whenever --update-crontab
```

#### 6. Then, As mentioned in the requirement to open the application one user should be added by the admin first then he/she can log in to the system by the Google account added by the admin. So to create an admin user firstly visit the below link use the Super Admin Password to add a Admin User 

[To add the first admin user](http://localhost:3000/superuser/add/adminuser)

```
Super Admin Password is : tasksuperadmin@123
```

#### 5. Then Log in to the system through that Google account which email is added to the above  added at the above link

### Then to check the rspec report file run the following command

```bash 
xdg-open coverage/index.html

```

#### Then the admin can add more users to log in to the system by adding users to the admin panel


