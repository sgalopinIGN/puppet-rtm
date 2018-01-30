class rtm::git (
    String $git_clone_directory = '/root/tmp/rtm/sources'
) {
    package { 'subversion':
      ensure => 'installed'
    }->
    exec { "svn co http://ifn-dev.ign.fr/svn/RTM/trunk ${git_clone_directory}":
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => "test -f ${git_clone_directory}/README.txt",
    }

    exec { "sudo sed -i '$ a 172.27.5.200 ifn-dev' /etc/hosts":
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => 'cat /etc/hosts | grep ifn-dev',
    }

    # The excludes parameters doesn't work with svn provider
    # The includes parameters use 'svn update' command and so doesn't checkout the externals
    # The 'svn co' done (when there are no inludes or excludes parameters)
    # with that module throws an encoding error on the dir 'Bases SQL/donnees_fournies_par_RTM/'
    # vcsrepo { $git_clone_directory:
    #     ensure   => present,
    #     provider => svn,
    #     source   => 'http://ifn-dev.ign.fr/svn/RTM/trunk',
    # }
}