# == Class: mongodb
#
# Manage mongodb installations on RHEL, CentOS, Debian and Ubuntu - either
# installing from the 10Gen repo or from EPEL in the case of EL systems.
#
# === Parameters
#
# enable_10gen (default: false) - Whether or not to set up 10gen software repositories
# init (auto discovered) - override init (sysv or upstart) for Debian derivatives
# location - override apt location configuration for Debian derivatives
# packagename (auto discovered) - override the package name
# servicename (auto discovered) - override the service name
#
# === Examples
#
# To install with defaults from the distribution packages on any system:
#   include mongodb
#
# To install from 10gen on a EL server
#   class { 'mongodb':
#     enable_10gen => true,
#   }
#
# === Authors
#
# Craig Dunn <craig@craigdunn.org>
#
# === Copyright
#
# Copyright 2012 PuppetLabs
#
class mongodb (
  $enable_10gen    = false,
  $init            = $mongodb::params::init,
  $location        = '',
  $packagename     = undef,
  $servicename     = $mongodb::params::service,
  $config_hash     = {}
) inherits mongodb::params {

  if $enable_10gen {
    include $mongodb::params::source
    Class[$mongodb::params::source] -> Package['mongodb-10gen']
  }

  if $packagename {
    $package = $packagename
  } elsif $enable_10gen {
    $package = $mongodb::params::pkg_10gen
  } else {
    $package = $mongodb::params::package
  }

  Package['mongodb-10gen'] -> Class['mongodb::config']

  $config_class = { 'mongodb::config' => $config_hash }

  create_resources( 'class', $config_class )

  package { 'mongodb-10gen':
    name   => $package,
    ensure => installed,
  }

  file { $mongodb::params::upstartfile:
    ensure    => present,
    content   => template("${module_name}/mongodb.upstart.erb"),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    notify    => Service['mongodb'],
    require   => Package['mongodb-10gen'],
    before    => Service['mongodb'],
  }

  service { 'mongodb':
    name      => $servicename,
    ensure    => running,
    enable    => true,
    subscribe => File[$mongodb::params::config_file],
  }
}
