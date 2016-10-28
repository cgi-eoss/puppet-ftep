# == Class: ftep::backend::zoo_kernel
#
# Install and manage ZOO-Project's zoo-kernel WPS server.
#
class ftep::backend::zoo_kernel(
  $manage_zoo_kernel = true,
  $manage_package    = true,
  $package_ensure    = 'present',
  $package_name      = 'zoo-kernel',
  $config_path       = '/usr/lib/cgi-bin',
  $main_config_file  = 'main.cfg',

  # zoo-kernel config
  $wps_version       = '1.0.0',
  $lang              = 'en-GB',
  $server_address    = 'https://forestry-tep.eo.esa.int/zoo',
  $data_path         = '/var/www/temp',
  $tmp_path          = '/data/cache',
  $tmp_url           = '../ftep-output',
  $cache_dir         = '/tmp',

  $provider_name     = 'CGI IT UK Ltd.',
  $provider_site     = 'https://forestry-tep.eo.esa.int/',

  $db_name           = 'ftep',
  $db_host           = 'localhost',
  $db_port           = '5432',
  $db_type           = 'PG',
  $db_schema         = 'public',
  $db_user           = 'ftep',
  $db_pass           = 'ftep',

  $env_config = { },
  $ftep_config = { },
  $other_config = { },
) {

  if ($manage_zoo_kernel) {
    if ($manage_package) {
      $_package_ensure = $package_ensure ? {
        true     => 'present',
        false    => 'purged',
        'absent' => 'purged',
        default  => $package_ensure,
      }

      ensure_resource(package, 'zoo-kernel', {
        ensure  => $_package_ensure,
        name    => $package_name,
        # Tag for resource ordering
        tag     => 'ftep',
      })
    }

    file { "${config_path}/${main_config_file}":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      content => epp('ftep/backend/zoo_kernel/main.cfg.epp', {
        'wps_version'    => $wps_version,
        'lang'           => $lang,
        'server_address' => $server_address,
        'data_path'      => $data_path,
        'tmp_path'       => $tmp_path,
        'tmp_url'        => $tmp_url,
        'cache_dir'      => $cache_dir,

        'provider_name'  => $provider_name,
        'provider_site'  => $provider_site,

        'db_name'        => $db_name,
        'db_host'        => $db_host,
        'db_port'        => $db_port,
        'db_type'        => $db_type,
        'db_schema'      => $db_schema,
        'db_user'        => $db_user,
        'db_pass'        => $db_pass,

        'env_config'     => $env_config,
        'ftep_config'    => $ftep_config,
        'other_config'   => $other_config,
      }),
    }
  }

}