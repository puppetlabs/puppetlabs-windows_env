v2.0.2
-------
- Fix formatting for puppetforge's markdown interpreter (version bump needed to push to puppetforge)

v2.0.1
------
- Fix documentation (version bump needed to push to puppetforge)

v2.0.0
======
- Remove 'manifests' directory. This directory had nothing useful in it. 
- Fixed name in Modulefile (was erroneously 'badgerious-puppet_env' now is 'badgerious-windows_env'). 
- Add 'user' parameter to allow user specific variables to be managed. 
- Changed default 'broadcast_timeout' to 100ms. Puppet usually runs in the background, where the broadcasting
  doesn't work anyway. There's no reason to be waiting for updates to go through that won't affect any users.

v1.0.0
======
- Ensure now defaults to 'present'.
- New parameter added, 'type'. Allows selection between REG_SZ or REG_EXPAND_SZ registry keys.
