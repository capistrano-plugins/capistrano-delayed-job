# Capistrano::DelayedJob

Capistrano tasks for automatic DelayedJob configuration.

Goals of this plugin:

* automatic DelayedJob configuration for Rails apps
* **no manual ssh** to the server required

Specifics:

* generates an init script on the server for Delayed job
* capistrano tasks for management, example: `delayed_job:restart`<br/>
see below for all available tasks

`capistrano-delayed-job` works only with Capistrano 3!

Inspired by
[capistrano-nginx-unicorn](https://github.com/bruno-/capistrano-nginx-unicorn) and [capistrano-recipes](https://github.com/mattdbridges/capistrano-recipes).

### Installation

Add this to `Gemfile`:

    group :development do
      gem 'capistrano', '~> 3.1'
      gem 'capistrano-delayed-job', '~> 1.0'
    end

And then:

    $ bundle install

### Setup and usage

Add this line to `Capfile`

    require 'capistrano/delayed_job'

**Setup task**

Make sure the `deploy_to` path exists and has the right privileges on the
server (i.e. `/var/www/myapp`).<br/>
Or just install
[capistrano-safe-deploy-to](https://github.com/bruno-/capistrano-safe-deploy-to)
plugin and don't think about it.

To setup the DelayedJob on the servers with the `delayed_job_server_role` (default `:app`) run:

    $ bundle exec cap production setup
    
This will generate the init script for delayed job.

### Configuration

As described in the Usage section, this plugin works with minimal setup.
However, configuration is possible.

You'll find the options and their defaults below.

In order to override the default, put the option in the stage file, for example:

    # in config/deploy/production.rb
    set :delayed_job_workers, 10

Defaults are listed near option name in the first line.

* `set :delayed_job_workers` # defaults to 1<br/>
The number of workers to run on each server.

* `set :delayed_job_server_roles, "[:app]"`<br/>
The roles on which the DelayedJob should run.

* `set :delayed_job_service, -> { "delayed_job_#{fetch(:application)}_#{fetch(:stage)}" }`<br/>
The name of the service that DelayedJob uses.

### Template customization

If you want to change default templates, you can generate them using
`rails generator`:

    $ bundle exec rails g capistrano:delayed_job:config

This will copy default templates to `config/deploy/templates` directory, so you
can customize them as you like, and capistrano tasks will use this templates
instead of default.

You can also provide path, where to generate templates:

    $ bundle exec rails g capistrano:delayed_job:config config/templates

### More Capistrano automation?

If you'd like to streamline your Capistrano deploys, you might want to check
these zero-configuration, plug-n-play plugins:

- [capistrano-unicorn-nginx](https://github.com/bruno-/capistrano-unicorn-nginx)<br/>
no-configuration unicorn and nginx setup with sensible defaults
- [capistrano-postgresql](https://github.com/bruno-/capistrano-postgresql)<br/>
plugin that automates postgresql configuration and setup
- [capistrano-rbenv-install](https://github.com/bruno-/capistrano-rbenv-install)<br/>
would you like Capistrano to install rubies for you?
- [capistrano-safe-deploy-to](https://github.com/bruno-/capistrano-safe-deploy-to)<br/>
if you're annoyed that Capistrano does **not** create a deployment path for the
app on the server (default `/var/www/myapp`), this is what you need!

### Bug reports and pull requests

...are very welcome!

### Thanks

[@bruno-](https://github.com/bruno-) - for his
[capistrano-unicorn-nginx](https://github.com/bruno-/capistrano-unicorn-nginx) plugin on which this
one is based.