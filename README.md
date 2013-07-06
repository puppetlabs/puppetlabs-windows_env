windows_env
===========

This module manages Windows environment variables (currently only system environment variables). 

Installation
------------

Install from puppet forge:

    puppet module install badgerious/windows_env

Install from git (do this in your modulepath):

    git clone https://github.com/badgerious/puppet-windows-env windows_env

It is important that the folder where this module resides is named windows_env, not puppet-windows-env.

Usage
-----

### Parameters

#### `ensure`
Standard ensure, valid values are `absent` or `present`. Defaults to `present`. 

#### `variable` (namevar)
The name of the environment variable. This will be inferred from the title if
not given explicitly. The title can be of either the form `{variable}={value}`
(the fields will be split on the first `=`) or just `{variable}`. 

#### `value` (namevar)
The value of the environment variable. How this will treat existing content
depends on `mergemode`. 

#### `separator`
How to split entries in environment variables with multiple values (such as
`PATH` or `PATHEXT`) . Default is `';'`. 

#### `mergemode`
Specifies how to treat content already in the environment variable, and how to
handle deletion of variables. Default is `insert`. 

Valid values:

- `clobber`
  - When `ensure => present`, creates a new variable (if necessary) and sets
    its value. If the variable already exists, its value will be overwritten.
  - When `ensure => absent`, the environment variable will be deleted entirely. 
- `prepend`
  - When `ensure => present`, creates a new variable (if necessary) and sets
    its value. If the variable already exists, the puppet resource provided
    content will be merged with the existing content. The puppet provided
    content will be placed at the beginning, and separated from existing
    entries with `separator`. If the specified value is already in the
    variable, but not at the beginning, it will be moved to the beginning. In
    the case of multiple resources in `prepend` mode managing the same
    variable, the values will inserted in the order of evaluation (the last to
    run will be listed first in the variable).  Note that with multiple
    `prepend`s on the same resource, there will be shuffling around on every
    puppet run, since each resource will place its own value at the front of
    the list when it is run. Alternatively, an array can be provided to
    `value`.  The relative ordering of the array items will be maintained when
    they are inserted into the variable, and the shuffling will be avoided.
  - When `ensure => absent`, the value provided by the puppet resource will be
    removed from the environment variable. Other content will be left
    unchanged. The environment variable will not be removed, even if its
    contents are blank. 
- `append`
  - Same as `prepend`, except the new value will be placed at the end of the
    variable's existing contents rather than the beginning. 
- `insert`
  - Same as `prepend` or `append`, except that content is not required to be
    anywhere in particular. New content will be added at the end, but existing
    content will not be moved. This is probably the mode to use unless there
    are some conflicts that need to be resolved (the conflicts may be better
    resolved with an array given to `value` and with `mergemode => insert`). 

#### `type`
The type of registry value to use. Default is `undef` for existing keys (i.e.
don't change the type) and `REG_SZ` when creating new keys. 

Valid values:

- `REG_SZ`
  - This is a regular registry string item with no substitution. 
- `REG_EXPAND_SZ`
  - Values of this type will expand '%' enclosed strings (e.g. `%SystemRoot%`)
    derived from other environment variables. If you're on a 64-bit system, be
    careful here; puppet runs as a 32-bit ruby process, and may be subject to
    WoW64 registry redirection shenanigans. This module writes keys with the
    KEY_WOW64_64KEY flag, which on Windows 7+ (Server 2008 R2) systems will
    disable value rewriting. Older systems will rewrite certain values. The
    gory details can be found here:
    http://msdn.microsoft.com/en-us/library/windows/desktop/aa384232%28v=vs.85%29.aspx
    . 

#### `broadcast_timeout`
Specifies how long (in ms) to wait (per window) for refreshes to go through
when environment variables change. Default is 5000ms. This probably doesn't
need changing unless you're having issues with the refreshes taking a long time
(they generally happen nearly instantly). 

### Examples

    # Title type #1. Variable name and value are extracted from title, splitting on '='. 
    # Default 'insert' mergemode is selected and default 'present' ensure is selected, 
    # so this will add 'C:\code\bin' to PATH, merging it neatly with existing content. 
    windows_env { 'PATH=C:\code\bin': }

    # Title type #2. Variable name is derived from the title, but not value (because there is no '='). 
    # This will remove the environment variable 'BADVAR' completely.
    windows_env { 'BADVAR':
      ensure    => absent,
      mergemode => clobber,
    }

    # Title type #3. Title doesn't set parameters (because both 'variable' and 'value' have
    # been supplied manually). 
    # This will create a new environment variable 'MyVariable' and set its value to 'stuff'. 
    # If the variable already exists, its value will be replaced with 'stuff'. 
    windows_env {'random_title':
      ensure    => present,
      variable  => 'MyVariable',
      value     => 'stuff',
      mergemode => clobber,
    }

    # Variables with 'type => REG_EXPAND_SZ' allow other environment variables to be used
    # by enclosing them in percent symbols. 
    windows_env { 'JAVA_HOME=%ProgramFiles%\Java\jdk1.6.0_02':
      type => REG_EXPAND_SZ,
    }

    # Creates (if needed) an enviroment variable 'VAR', and sticks 'VAL:VAL2' at
    # the beginning. Separates with : instead of ;. The broadcast_timeout change
    # probably won't make any difference. 
    windows_env { 'title':
      ensure            => present,
      mergemode         => prepend,
      variable          => 'VAR',
      value             => ['VAL', 'VAL2'],
      separator         => ':',
      broadcast_timeout => 2000,
    }

### Things that won't end well
Certain conflicts can occur which may cause unexpected behavior (which you won't be warned about):

- Multiple resource declarations controlling the same environment variable with
  at least one in `mergemode => clobber`. Toes will be stepped on. 
- Multiple resource declarations controlling the same environment variable with
  different `type`s. More squished toes. 

Compatibility
-------------
This module has been tested against a 3.2.1 puppetmaster, 2.7.21 and 3.2.1 agents. 

Acknowledgements
----------------
The [puppet-windows-path](https://github.com/basti1302/puppet-windows-path) module by Bastian Krol was the starting point for this module. 
