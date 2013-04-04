define mongodb::replica_set(
  $repl_name = $title,
  $repl_config = undef
) {
  validate_hash($repl_config)

  $my_repl_config = $repl_config['nodes'][$::hostname]
  $first_node_name = keys($repl_config['nodes'])[0]

  if $my_repl_config['_id'] == 0 {
    exec { "initiate replica set":
      command => 'mongo --eval "rs.initiate()"',
      onlyif  => 'test `mongo --eval "rs.conf()" | grep "null"`',
    }
  }
  else {
    #exec { "add member to set":
    #  command => "/root/bin/mongo_helper/add_members.sh ${first_node_name} ${my_repl_config['_id']} ${::hostname}.${::hostname_base} ${my_repl_config['priority']}",
    #  onlyif  => ""
    #  require => File['/root/bin/mongo_helper/add_members.sh'],
    #}
  }

  file { "/root/bin":
    ensure => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/root/bin/mongo_helper':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/root/bin']
  }

  file { '/root/bin/mongo_helper/add_members.sh':
    ensure  => present,
    content => template("${module_name}/add_members.sh.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/root/bin/mongo_helper']
  }
}