module Capistrano
  module DSL
    module DelayedJobPaths

      def delayed_job_initd_file
        "/etc/init.d/#{fetch(:delayed_job_service)}"
      end

      # install the delayed_job monit configuration in the conf.d directory, where it will
      # automaticaly be picked up by monit
      def delayed_job_monitrc_file
        "/etc/monit/conf.d/#{fetch(:delayed_job_service)}.monitrc"
      end

      def current_path
        deploy_path.join('current')
      end

    end
  end
end
