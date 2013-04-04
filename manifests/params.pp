class mongodb::params{
  case $::osfamily {
    'redhat': {
      $baseurl = "http://downloads-distro.mongodb.org/repo/redhat/os/${::architecture}"
      $source  = 'mongodb::sources::yum'
      $package = 'mongodb-server'
      $service = 'mongod'
      $pkg_10gen = 'mongo-10gen-server'
      $config_file = '/etc/mongodb.conf'
      # Params still missing
    }
    'debian': {
      $locations = {
        'sysv'    => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
        'upstart' => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart'
      }
      case $::operatingsystem {
        'Debian': { $init = 'sysv' }
        'Ubuntu': {
          $init         = 'upstart',
          $upstartfile  = '/etc/init/mongodb.conf'
        }
      }
      $ulimit_open_files  = 65000
      $ulimit_processes   = 32000
      $source             = 'mongodb::sources::apt'
      $package            = 'mongodb'
      $service            = 'mongodb'
      $pkg_10gen          = 'mongodb-10gen'
      $config_file        = '/etc/mongodb.conf'
      $dbpath             = '/var/lib/mongodb'
      $logpath            = '/var/log/mongodb/mongodb.log'
      $logappend          = true
      $port               = '27017'
      $nojournal          = false
      $cpu                = false
      $noauth             = true
      $auth               = false
      $verbose            = false
      $objcheck           = true
      $noobjcheck         = false
      $quota              = false
      $diaglog            = 0
      $nohttpinterface    = false
      $noscripting        = false
      $notablescan        = false
      $noprealloc         = false
      $nssize             = 16
      $master             = false
      $slave              = false
      $slaveDelay         = 0
      $autoresync         = false
      $fastsync           = false
      $replIndexPrefetch  = 'all'
    }
    default: {
      fail ("mongodb: ${::operatingsystem} is not supported.")
    }
  }
}
