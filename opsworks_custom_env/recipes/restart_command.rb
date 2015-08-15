node[:deploy].each do |application, deploy|

  execute "restart Rails app #{application} for custom env" do
    cwd deploy[:current_path]
    if node[:opsworks][:rails_stack][:name].eql? "apache_passenger"
      command "touch #{deploy[:deploy_to]}/current/tmp/restart.txt"
    elsif node[:opsworks][:rails_stack][:name].eql? "nginx_unicorn"
      command "#{deploy[:deploy_to]}/shared/scripts/unicorn clean-restart"
    elsif node[:sidekiq][application]
      command node[:opsworks][:rails_stack][:restart_command]
    end
    user deploy[:user]

    action :nothing
  end

end
