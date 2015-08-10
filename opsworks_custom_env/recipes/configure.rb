if %w(rails-app sidekiq).include?(node[:opsworks][:instance][:layers])

  include_recipe "opsworks_custom_env::restart_command"
  include_recipe "opsworks_custom_env::write_config"

end
