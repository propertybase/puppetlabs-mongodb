define mongodb::replica_set(
  $repl_name = $title,
  $repl_config = undef
) {
  validate_hash($repl_config)

  if $repl_config['_id'] == 0 {
    exec { "initiate replica set":
      command => 'mongo --eval "rs.initiate()"',
      onlyif  => 'test `mongo --eval "rs.conf()" | grep "null"`',
      before  => Notify['replica set initiated'],
    }

    notify {'replica set initiated':
      message => "Replica Set is initiated with rs.initiate() on ${$::hostname}"
    }
  }
  else {
    notify{"Replica Set will not be initiated on this host.":}
  }
}