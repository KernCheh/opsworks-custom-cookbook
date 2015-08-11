
include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "/etc/monit/conf.d/#{application}_sneakers_worker.monitrc" do
    source 'sneakers_worker.monitrc.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :app => application,
      :env => deploy[:rails_env],
      :dir => deploy[:deploy_to],
      :user => deploy[:user],
      :group => deploy[:group],
      :workers => deploy[:sneakers_worker] && deploy[:sneakers_worker].join(',')
    )
    only_if { deploy[:sneakers_worker] }
  end
end
