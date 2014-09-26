module Capistrano
  module DSL
    module DelayedJobPaths

      def delayed_job_initd_file
        "/etc/init.d/#{fetch(:delayed_job_service)}"
      end

      def current_path
        deploy_path.join('current')
      end

    end
  end
end
