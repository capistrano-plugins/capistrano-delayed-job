require 'erb'

module Capistrano
  module DelayedJob
    module Helpers

      def bundle_delayed_job(*args)
        bin_dir = %w{bin script}.find{|dir_name| Dir.exists?(dir_name)}
        raise "No bin or script dir found in project" if bin_dir.nil?
        SSHKit::Command.new("HOME=/home/$AS_USER", "RAILS_ENV=#{fetch(:rails_env)}", :nice, '-n 15', :bundle, :exec, "#{bin_dir}/delayed_job", args).to_command
      end

      def dj_template(template_name)
        config_file = "#{fetch(:templates_path)}/#{template_name}"
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
        capture :id, '-un'
      end

      def sudo_upload!(from, to)
        filename = File.basename(to)
        to_dir = File.dirname(to)
        tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

    end
  end
end
