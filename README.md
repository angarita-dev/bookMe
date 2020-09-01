# BookMe!

API service to book rooms/work-spaces using Ruby on Rails.

## Tech stack

* Ruby on Rails as REST API.
* Deployed on [Heroku.](https://www.heroku.com/)
* Database [PostgreSQL.](https://www.postgresql.org/)
* Frontend using [React](https://reactjs.org) & [Redux.](https://redux.js.org/)
* Tests using [rspec](https://github.com/rspec/rspec-rails), [factory-bot](https://github.com/thoughtbot/factory_bot_rails), [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers), [database-cleaner](https://github.com/DatabaseCleaner/database_cleaner) & [faker.](https://github.com/faker-ruby/faker)

## How to install

Brief guide on how to install and run this project locally.

### Requirements

#### Clone the project

To download the project simply run: 

`git clone git@github.com:codingAngarita/bookMe.git`

or

`git clone https://github.com/codingAngarita/bookMe.git`

Then move into the created directory `cd bookMe`

#### Ruby Version

This projects uses `ruby 2.7.0` you can install ruby using [RVM](https://rvm.io/) or check the [ruby language page](https://www.ruby-lang.org/es/).

### Database

To run this project locally you should provide the local PostgreSQL `role` and `password` you can check [this guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-ruby-on-rails-with-postgres) for mor info.

#### Install PostgreSQL

Install PostgreSQL and it's required development libraries.

`sudo apt install postgresql postgresql-contrib libpq-dev`

#### Creating a Role

The `role` as it's called on Postgre it's basically your username, using this role rails will create and communicate with the Database.

`sudo -u postgres createuser -s YOUR_DB_ROLE_NAME -P`

`sudo -u` Allows to run the `createuser` command ussing the `postgres` role thats automatically created upon installing.

The `-s` flag will tell posrgres to create a user with super user privileges, and using the `-P` flag you will be asked to enter a password for your new role.

#### Enviroment variables

This project uses [dotenv](https://github.com/bkeepers/dotenv) to manage database role credentials

Create a `.env` file on the root of the project.

```
# .env

BOOKME_DATABASE_USER=YOUR_DB_ROLE_NAME
BOOKME_DATABASE_PASSWORD=YOUR_DB_ROLE_PASSWORD
```

This env variables are used in `config/database.yml` to securely connect to the local database

### Gems

#### Install Bundler

This project uses `bundler 2.1.2` check if you have it installed using `bundler --version`.

You can install the bundler gem using running:

`gem install bundler -v 2.1.2`

#### Install required gems

Run the command `bundle` or `bundle install`.

### Final setup

Once you are done following the previous steps you should run:

1. `rails db:create` to create the local database.
2. `rake db:migrate` to run any pending migrations.

You can now start the server by running `rails s`

## Project details

Check the ERD (Entity Relationship Design) here:

![ERD](https://i.imgur.com/ZWKEriT.jpg)
