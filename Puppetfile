#!/usr/bin/env ruby
#^syntax detection

## Test with librarian-puppet if you have all dependencies listed
## Exclude modules you don't need
# librarian-puppet install --verbose --clean

## r10k also can install the modules from the Puppetfile,
## but does not resolve dependencies
# r10k puppetfile install --verbose

## exclude conflicting and modules unnecessary on ubuntu
##exclusion 'ckhall-remi'
##exclusion 'stahnma-epel'
#
## don't pull from forge, I want all from git.
#forge "https://forgeapi.puppetlabs.com"

#To specify a module installation path other than the default modules directory
#Set moduledir to your module installation directory
#moduledir 'thirdparty'

moduledir '/usr/share/puppet/modules'

mod 'puppetlabs-stdlib',
  :git => 'https://github.com/puppetlabs/puppetlabs-stdlib',
  :tag => '4.13.1'

mod 'puppetlabs-java',
  :git => 'https://github.com/puppetlabs/puppetlabs-java.git',
  :tag => '2.1.0'

mod 'puppetlabs-apt',
  :git => 'https://github.com/puppetlabs/puppetlabs-apt.git',
  :tag => '2.1.0'

mod 'puppetlabs-concat',
  :git => 'https://github.com/puppetlabs/puppetlabs-concat.git',
#  :ref => 'master'
  :tag => '3.0.0'

mod 'puppetlabs-ntp',
  :git => 'https://github.com/puppetlabs/puppetlabs-ntp.git',
  :tag => '6.2.0'

mod 'puppet-archive',
  :git => 'https://github.com/voxpupuli/puppet-archive.git',
  :tag => 'v1.1.2'

mod 'puppet-nginx',
  :git => 'https://github.com/voxpupuli/puppet-nginx.git',
  :tag => 'v0.7.0'

mod 'ikeautomata',
  :git => 'https://github.com/onnorom/ikeautomata.git',
  :tag => '0.1.17'
#  :branch => 'master'

#  :install_path => 'code/modules' 

#mod 'site_data', 
#  :git: 'git@git.example.com:site_data.git',
#  :install_path: 'hieradata'
#  Use the install_path to separate your data from modules.
