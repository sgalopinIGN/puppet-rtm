class rtm::mapserv (
    String $git_clone_directory = '/root/tmp/rtm/sources',
    String $conf_directory = '/etc/rtm',
    String $log_directory = '/var/log/rtm',
) {
    $enhancers = [ 'cgi-mapserver', 'mapserver-bin', 'gdal-bin', 'mapserver-doc', 'libapache2-mod-fcgid' ]
    package { $enhancers: ensure => 'installed' }

    file { "${conf_directory}/mapserver":
      ensure  => 'directory',
      recurse => true,
      source => "${git_clone_directory}/mapserver",
      group   => 'www-data',
    }
    # mapserv is a fcgi compatible, use default config sethandler with .fcgi
    file { '/usr/lib/cgi-bin/mapserv.fcgi':
        ensure  => link,
        target => '/usr/lib/cgi-bin/mapserv',
    }
    exec { [  "sed -i 's|vrtm-onf.ifn.fr|${fqdn}|' rtm.map",
              "sed -i 's|/vagrant/rtm/website/htdocs/logs|${log_directory}|' rtm.map",
              "sed -i 's|/vagrant/rtm/mapserver|${conf_directory}/mapserver|' rtm.map" ]:
      path     	=> '/usr/bin:/usr/sbin:/bin',
      cwd 		  => "${conf_directory}/mapserver",
    }
}
