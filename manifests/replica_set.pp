define mongodb::replica_set(
  $name = $title,
  $config = undef
) {
  validate_hash($config)

  if $config['_id'] == 0 {
    exec { "initiate replica set":
      command => 'mongo --eval "rs.initiate()"'
      onlyif  => 'test `mongo --eval "rs.conf()" | grep "null"`',
    }
  }
}