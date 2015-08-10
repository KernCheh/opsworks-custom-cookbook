Chef::Log.debug("Current layer is #{node[:opsworks][:instance][:layers]}")

if %w(rails-app sidekiq).include?(node[:opsworks][:instance][:layers])

  include_recipe "opsworks_custom_env::restart_command"
  include_recipe "opsworks_custom_env::write_config"

end
