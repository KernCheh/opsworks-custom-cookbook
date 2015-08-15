node[:deploy].each do |application, deploy|

  # Precompile assets. Assets are compiled into shared/assets and shared between deploys.
  shared_path = "#{deploy[:deploy_to]}/shared"
  release_path = "#{deploy[:deploy_to]}/current"

  # create shared directory for assets, if it doesn't exist
  directory "#{shared_path}/assets" do
    mode 0770
    action :create
    recursive true
  end

  # symlink current deploy's asset folder to shared assets each deploy
  link "#{release_path}/public/assets" do
    to "#{shared_path}/assets"
  end

  # precompile assets into public/assets (which is symlinked to shared assets folder)
  execute "rake assets:precompile" do
    cwd release_path
    command "/bin/su deploy -c 'bundle exec rake assets:precompile'"
    environment 'RAILS_ENV' => node[:deploy][application][:rails_env]
  end

  execute "restart Rails application #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
  end
end
