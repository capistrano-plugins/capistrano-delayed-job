require 'erb'

module Capistrano
  module DelayedJob
    module Helpers

      def delayed_job_command(*args)
        "cd #{current_path} && " <<
            SSHKit::Command.new("HOME=/home/#{deploy_user}",
                                "RAILS_ENV=#{fetch(:rails_env)}",
                                :nice,
                                '-n 15',
                                :bundle,
                                :exec,
                                delayed_job_script_relative_path,
                                args).to_command
      end

      def dj_template(template_name)
        templates_path = fetch(:templates_path) || "config/deploy/templates"
        config_file = "#{templates_path}/#{template_name}"
        # if no customized file, proceed with default
        unless File.exists?(config_file)
          config_file = File.join(File.dirname(__FILE__), "../../generators/capistrano/delayed_job/templates/#{template_name}")
        end
        StringIO.new(ERB.new(File.read(config_file)).result(binding))
      end

      def file_exists?(path)
        test "[ -e #{path} ]"
      end

      def deploy_user
        @deploy_user ||= capture(:id, '-un')
      end

      def sudo_upload!(from, to)
        filename = File.basename(to)
        to_dir = File.dirname(to)
        tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

      def delayed_job_script_relative_path
        "#{relative_bin_path}/delayed_job"
      end

      private
      def relative_bin_path
        bin_path = %w{bin script}.find { |dir_name| Dir.exists?(dir_name) }
        raise "No bin or script dir found in project" if bin_path.nil?
        bin_path
      end
    end
  end
end
