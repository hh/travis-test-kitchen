name            'lunchies'
maintainer       'Vulk.io'
maintainer_email 'cookbooks@vulk.io'
license          'Apache 2.0'
description      'Installs/Configures lunchies'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

# depends 'java'
# depends 'openssl'

depends 'rvm'
depends 'yum-epel'
# depends 'rbenv'
# depends 'ruby_build'

# supports 'debian'
# supports 'ubuntu'
supports 'centos'
# supports 'redhat'
# supports 'amazon'
# supports 'scientific'

# recipe 'tomcat::default', 'Installs and configures Tomcat'
# recipe 'tomcat::users', 'Setup users and roles for Tomcat'
