class postgresql::server::postconfig{

  $dbs = $postgresql::server::dbs
  $pg_hba_rules = $postgresql::server::pg_hba_rules

  create_resources(postgresql::server::db, $dbs)
  create_resources(postgresql::server::pg_hba_rule, $pg_hba_rules)

}