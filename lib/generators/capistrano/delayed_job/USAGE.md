To create local delayed_job configuration files call

    bundle exec rails generate capistrano:delayed_job:config [path]

The default path is "config/deploy/templates". You can override it like so:

    bundle rails generate capistrano:delayed_job:config "config/templates"

If you're using a custom path, set "templates_path" variable in your `deploy.rb`:

    set :templates_path, "config/deploy/templates"
