# Define for conveniently creating a role, database and assigning the correct
# permissions. See README.md for more details.
define postgresql::server::db (
  $user,
  $password,
  $dbname     = $title,
  $encoding   = $postgresql::server::encoding,
  $locale     = $postgresql::server::locale,
  $grant      = 'ALL',
  $tablespace = undef,
  $template   = 'template0',
  $istemplate = false,
  $owner      = undef
) {

  $password_hash = postgresql_password($user, $password)

  if ! defined(Postgresql::Server::Database[$dbname]) {
    postgresql::server::database { $dbname:
      encoding   => $encoding,
      tablespace => $tablespace,
      template   => $template,
      locale     => $locale,
      istemplate => $istemplate,
      owner      => $owner,
    }
  }

  if ! defined(Postgresql::Server::Role[$user]) {
    postgresql::server::role { $user:
      password_hash => $password_hash,
    }
  }

  if ! defined(Postgresql::Server::Database_grant["GRANT ${user} - ${grant} - ${dbname}"]) {
    postgresql::server::database_grant { "GRANT ${user} - ${grant} - ${dbname}":
      privilege => $grant,
      db        => $dbname,
      role      => $user,
    } -> Postgresql::Validate_db_connection<| database_name == $dbname |>
  }

  if($tablespace != undef and defined(Postgresql::Server::Tablespace[$tablespace])) {
    Postgresql::Server::Tablespace[$tablespace]->Postgresql::Server::Database[$name]
  }
}
