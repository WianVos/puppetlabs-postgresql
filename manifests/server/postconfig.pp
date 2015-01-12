class postgresql::server::postconfig{

  $dbs = $postgresql::server::dbs

  create_resources(postgresql::server::db, $dbs)

}