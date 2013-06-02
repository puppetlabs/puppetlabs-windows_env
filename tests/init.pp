class windows_env {
  ### SHOULD FAIL ###

  # ensure => present, but no value
  windows_env { 'SHOULD_FAIL1':
    ensure => present,
  }
  # ensure => absent, mergemode => insert, but no value
  windows_env { 'SHOULD_FAIL2':
    mergemode => insert,
    ensure    => absent,
  }

  ### SHOULD PASS ###

  # Should insert 'C:\foo' at end of PATH
  windows_env { 'PATH=C:\foo':
    ensure    => present,
    mergemode => append,
  }

  # Should insert 'C:\hello;C:\byebye' at the front of PATH
  windows_env { 'PATH':
    mergemode => prepend,
    ensure    => present,
    value     => ['C:\hello', 'C:\byebye'],
  }

  # Should insert 'value' into 'PATH'
  windows_env { 'Puppet':
    variable  => 'PATH',
    value     => 'C:\Program Files (x86)\Puppet Labs\Puppet\bin',
    ensure    => present,
    mergemode => insert,
  }

  # Should create an environment variable 'JIMMY' with value
  # 'ah-ja'
  windows_env { 'JIMMY=ah-ja':
    mergemode => clobber,
    ensure    => present,
  }

  # Should create environment variable 'TESTER2' with value
  # "hello:there"
  windows_env {'TESTER':
    variable  => 'TESTER2',
    mergemode => clobber,
    ensure    => present,
    value     => ['hello', 'there'],
    separator => ':',
  }

  # Should create a variable 'DELETME', and then delete it. 
  windows_env { 'DELETEME1':
    mergemode => clobber,
    ensure    => present,
    value     => '',
    variable  => 'DELETEME',
  }->
  windows_env { 'DELETEME2':
    mergemode => clobber,
    ensure    => absent,
    variable  => 'DELETEME',
  }

  # Should remove 'C:\path' from PATH. 
  windows_env { 'DELETEME3':
    variable => 'PATH',
    ensure   => absent,
    value    => 'C:\path',
  }
}

