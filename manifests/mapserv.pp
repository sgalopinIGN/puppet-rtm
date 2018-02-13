class rtm::mapserv {

    $enhancers = [ 'cgi-mapserver', 'mapserver-bin', 'gdal-bin', 'mapserver-doc', 'libapache2-mod-fcgid' ]
    package { $enhancers: ensure => 'installed' }

    file { "${rtm::conf_directory}/mapserver":
      ensure => 'directory',
      recurse => true,
      source => "${rtm::git_clone_directory}/mapserver",
      group => 'www-data',
    }->
    ext_file_line { 'mapserver_map_url':
      ensure => present,
      path   => "${rtm::conf_directory}/mapserver/rtm.map",
      match  => '(.*)http://vrtm-onf.ifn.fr(.*)',
      line   => "\\1https://${rtm::vhost_servername}\\2",
    }->
    ext_file_line { 'mapserver_map_log_path':
      ensure => present,
      path   => "${rtm::conf_directory}/mapserver/rtm.map",
      match  => '(.*)/vagrant/ogam/website/htdocs/logs(.*)',
      line   => "\\1${rtm::log_directory}\\2",
    }->
    ext_file_line { 'mapserver_map_conf_path':
      ensure => present,
      path   => "${rtm::conf_directory}/mapserver/rtm.map",
      match  => '(.*)/vagrant/ogam/mapserver(.*)',
      line   => "\\1${rtm::conf_directory}/mapserver\\2",
    }

    # mapserv is a fcgi compatible, use default config sethandler with .fcgi
    file { '/usr/lib/cgi-bin/mapserv.fcgi':
        ensure => link,
        target => '/usr/lib/cgi-bin/mapserv',
    }
}