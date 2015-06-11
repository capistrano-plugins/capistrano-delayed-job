require 'capistrano/dsl/delayed_job_paths'
require 'capistrano/delayed_job/helpers'

include Capistrano::DelayedJob::Helpers
include Capistrano::DSL::DelayedJobPaths

namespace :load do
  task :defaults do
    set :delayed_job_workers, 1
    set :delayed_job_service, -> { "delayed_job_#{fetch(:application)}_#{fetch(:stage)}" }
    set :delayed_job_monit_enabled, false

    set :delayed_job_server_roles, [:app]
  end
end

namespace :delayed_job do

  task :defaults do
    on roles fetch(:delayed_job_server_roles) do
      set :delayed_job_user, fetch(:delayed_job_user, deploy_user)
    end
  end

  desc 'Setup DelayedJob initializer'
  task :setup do
    on roles fetch(:delayed_job_server_roles) do
      sudo_upload! dj_template('delayed_job_init.erb'), delayed_job_initd_file
      execute :chmod, '+x', delayed_job_initd_file
      sudo 'update-rc.d', '-f', fetch(:delayed_job_service), 'defaults'
    end
  end

  before :setup, :defaults

  %w[start stop].each do |command|
    desc "#{command} delayed_job"
    task command do
      on roles fetch(:delayed_job_server_roles) do
        if fetch(:delayed_job_monit_enabled)
          # monit is enabled, use it to restart the service
          sudo :monit, '-g', 'delayed_job', command
        else
          # monit is disabled, use the standard init script
          sudo :service, fetch(:delayed_job_service), command
        end
      end
    end
  end

  desc "restart delayed_job"
  task "restart" do
    on roles fetch(:delayed_job_server_roles) do
      if fetch(:delayed_job_monit_enabled)
        # monit is enabled, use it to restart the service
        sudo :monit, '-g', 'delayed_job', "restart"
      else
        # monit is disabled, use the standard init script
        sudo :service, fetch(:delayed_job_service), "stop"
        sudo :service, fetch(:delayed_job_service), "start"
      end
    end
  end

  namespace :monit do
    task :setup do
      on roles fetch(:delayed_job_server_roles) do
        sudo_upload! dj_template('delayed_job.monitrc.erb'), delayed_job_monitrc_file
        sudo :service, 'monit restart'
      end
    end
  end
end

namespace :deploy do
  after :publishing, 'delayed_job:restart'
end

desc 'Server setup tasks'
task :setup do
  invoke 'delayed_job:setup'
  invoke 'delayed_job:monit:setup' if fetch(:delayed_job_monit_enabled)
end
