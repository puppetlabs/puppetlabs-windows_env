windows_env
===========

This module manages Windows environment variables (currently only system environment variables). 

Installation
------------

Install from puppet forge:

    puppet module install badgerious/windows_env

Install from git (do this in your modulepath):

    git clone https://github.com/badgerious/puppet-windows-env windows_env

It is important that the folder where this module resisdes is named windows_env, not puppet-windows-env.

Usage
-----

### Parameters

#### `ensure`
Standard ensure, valid values are `absent` or `present`. 

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
    entires with `separator`. If the specified value is already in the
    variable, but not at the beginning, it will be moved to the beginning. In
    the case of multiple resources in `prepend` mode on the same variable, the
    last to be run will be placed at the front of the variable. Note that with
    multiple `prepend`s on the same resource, there will be shuffling around on
    every puppet run, since each resource will place its own value at the front
    of the list when it is run. If there are multiple values that need to be in
    a specific order and at the beginning, an array can be provided to `value`.
    The relative ordering of the array items will be maintained when they are
    inserted into the variable. 
  - When `ensure => absent`, the value provided by the puppet resource will be
    removed from the environment variable. Other content will be left
    unchanged. The environment variable will not be removed, even if its
    contents are blank. 
- `append`
  - Same as `prepend`, except content will be placed at the end of the
    variable's existing contents rather than the beginning. 
- `insert`
  - Same as `prepend` or `append`, except that content is not required to be
    anywhere in particular. New content will be added at the end, but existing
    content will not be moved. This is probably the mode to use unless there
    are some conflicts that need to be resolved (the conflicts may be better
    resolved with an array given to `value` and with `mergemode => insert`). 

#### `broadcast_timeout`
Specifies how long (in ms) to wait (per window) for refreshes to go through
when environment variables change. Default is 5000ms. This probably doesn't
need changing unless you're having issues with the refreshes.

### Examples

    # Title type #1. Variable name and value are extracted from title, splitting on '='. 
    # Default 'insert' mergemode is selected, so this will add 'C:\code\bin' to
    # PATH, merging it neatly with existing content. 
    windows_env { 'PATH=C:\code\bin':
      ensure => present,
    }

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
- Multiple resource declarations controlling the same environment variable with
  at least one in 'clobber' mode. Toes will be stepped on. 

Acknowledgements
----------------
The [puppet-windows-path](https://github.com/basti1302/puppet-windows-path) module by Bastian Krol was the starting point for this module. 
