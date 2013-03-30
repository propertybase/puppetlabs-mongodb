class mongodb::config(
  $config_file        = $mongodb::params::config_file,
  $dbpath             = $mongodb::params::dbpath,            # /var/lib/mongodb
  $logpath            = $mongodb::params::logpath,           # /var/log/mongodb/mongodb.log
  $logappend          = $mongodb::params::logappend,         # true
  $port               = $mongodb::params::port,              # 27017
  $bind_ip            = undef,
  $nojournal          = $mongodb::params::nojournal,         # false
  $cpu                = $mongodb::params::cpu,               # false
  $noauth             = $mongodb::params::noauth,            # true
  $auth               = $mongodb::params::auth,              # false
  $verbose            = $mongodb::params::verbose,           # false
  $objcheck           = $mongodb::params::objcheck,          # true
  $noobjcheck         = $mongodb::params::noobjcheck,        # false
  $quota              = $mongodb::params::quota,             # false
  $diaglog            = $mongodb::params::diaglog,           # 0
  $nohttpinterface    = $mongodb::params::nohttpinterface,   # false
  $noscripting        = $mongodb::params::noscripting,       # false
  $notablescan        = $mongodb::params::notablescan,       # false
  $noprealloc         = $mongodb::params::noprealloc,        # false
  $nssize             = $mongodb::params::nssize,            # 16
  $master_slave       = false,
  $master             = $mongodb::params::master,            # false
  $slave              = $mongodb::params::slave,             # false
  $source             = undef,
  $only               = undef,
  $slaveDelay         = $mongodb::params::slaveDelay,        # 0
  $autoresync         = $mongodb::params::autoresync,        # false
  $replica_set        = false,
  $replSet            = undef,
  $oplogSize          = undef,
  $fastsync           = $mongodb::params::fastsync,          # false
  $replIndexPrefetch  = $mongodb::params::replIndexPrefetch  # all
) inherits mongodb::params {

  file { $config_file:
    content => template('mongodb/mongodb.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb-10gen'],
  }
}