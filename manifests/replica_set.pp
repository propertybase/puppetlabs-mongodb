define mongodb::replica_set(
  $repl_name          = $title,
  $repl_config        = undef,
  $cluster_first_node = undef
) {
  validate_hash($repl_config)

  $my_repl_config = $repl_config['nodes'][$::hostname]
  $repl_nodes = keys($repl_config['nodes'])
  $mongo_port = getparam(Class["mongodb::config"], "port")

  if $my_repl_config['_id'] == 0 {
    exec { "initiate replica set":
      command => 'mongo --eval "rs.initiate()"',
      onlyif  => 'test `mongo --eval "rs.conf()" | grep "null"`',
      require => Exec['wait for mongodb'],
    }
  }
  else {
    exec { "add member to set":
      command => "sudo /tmp/add_members.sh ${cluster_first_node} ${my_repl_config['_id']} ${::hostname}.${::hostname_base}:${mongo_port} ${my_repl_config['priority']}",
      unless  => "mongo --host ${cluster_first_node} --eval \"printjson(rs.status()['members'])\" | grep \"${::hostname}.${::hostname_base}\"",
      require => [
        File['/tmp/add_members.sh'],
        Exec['wait for mongodb']
      ]
    }
  }

  exec { "wait for mongodb":
    command     => "mongo --eval 'rs.status()'",
    tries       => 10,
    try_sleep   => 2,
    returns     => 0,
    require     => Service['mongodb'],
  }

  file { '/tmp/add_members.sh':
    ensure  => present,
    source  => 'puppet:///modules/mongodb/add_members.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0755'
  }
}