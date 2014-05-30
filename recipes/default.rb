#
# Cookbook Name:: lunchies
# Recipe:: default
#
# Copyright 2014, Vulk.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'git'
# package 'ruby'
# package 'rubygems'
#gem 'bundler'



user node[:lunchies][:user]

directory "/home/#{node[:lunchies][:user]}/.ssh" do
  mode '0700'
  owner node[:lunchies][:user]
end

file "/home/#{node[:lunchies][:user]}/.ssh/known_hosts" do
  user node[:lunchies][:user]
  content <<EOF
github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
bitbucket.org,131.103.20.168 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==
EOF
end

# include_recipe 'ruby_build' # ensure ruby_build is installed

# global
# ruby_build_ruby node[:lunchies][:ruby_version] # builds our version
# rbenv_gem 'rake' do
#   ruby_version node[:lunchies][:ruby_version]
# end

# rbenv_rehash 'doing the rehash dance'
# node.default['rbenv']['rubies'] = [node[:lunchies][:ruby_version],]
# node.default['rbenv']['user_rubies'] = [node[:lunchies][:ruby_version],]
# node.default['rbenv']['gems'] = {
#  node[:lunchies][:ruby_version] => [
#    { 'name' => 'bundler' },
#    { 'name' => 'rake' },
#  ]
# }
# per user
node.default['rvm']['user_installs'] = [{
  'user' => node[:lunchies][:user],
  'rubies' => [node[:lunchies][:ruby_version],],
#  'upgrade' => true,
  'default_ruby' => node[:lunchies][:ruby_version],
#  'global' => node[:lunchies][:ruby_version],
  'global_gems' => [
     { 'name' => 'bundler' },
     { 'name' => 'rake' },
   ],
}]

include_recipe 'yum-epel::default'
include_recipe 'rvm::user'
# include_recipe 'rbenv::user_install'
# rbenv_gem 'bundler' do
#   ruby_version node[:lunchies][:ruby_version]
# end
# include_recipe 'rbenv::user'
# include_recipe 'rbenv::system_install'
# rbenv_global node[:lunchies][:ruby_version] do
#   user node[:lunchies][:user]
# end

# link "/home/#{node[:lunchies][:user]}/.rbenv/versions/#{node[:lunchies][:ruby_version]}" do
#   to "/usr/local/ruby/#{node[:lunchies][:ruby_version]}"
# end


# rvm
directory node[:lunchies][:path] do
  user node[:lunchies][:user]
  recursive true
end

git node[:lunchies][:path] do
  repository node[:lunchies][:git_repository]
  revision node[:lunchies][:git_revision]
  enable_submodules true
  action :sync
  user node[:lunchies][:user]
  #  notifies :run, 'rbenv_script[setup lunchies]' # update me
  #  notifies :run, 'bash[compile_lunchies]' # update me
  notifies :run, 'rvm_shell[bake some lunch]' # update me
end

# bash 'compile_lunchies' do
#   cwd node[:lunchies][:path]
#   user node[:lunchies][:user]
#   code <<-EOB
#   bundle install
#   bundle exec ruby server.rb
#   EOB
# end

rvm_shell 'bake some lunch' do
  cwd node[:lunchies][:path]
  user node[:lunchies][:user]
  code <<-EOF
  bundle install
  rake test
EOF
end
# rbenv_script 'setup lunchies' do
#   ruby_version node[:lunchies][:ruby_version]
#   cwd node[:lunchies][:path]
#   user node[:lunchies][:user]
#   # group         "deploy"
#   code          %{bundle install --path vendor/gems}
# end
