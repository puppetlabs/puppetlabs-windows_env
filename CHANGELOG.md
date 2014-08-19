v2.2.0
------
- Puppet 3.7 / Ruby 64 bit compatibility changes.

v2.1.0
------
- Use `post_resource_eval` hook instead of monkey patching if possible.
- Some parameter validation moved into the Type (so it is caught earlier and
  gives a better error message).
- The validate stage now checks for multiple resources managing the same environment
  variable in an incompatible way (e.g. two resources in clobber mergemode) and raises
  an error if such conflicts are found.

### v2.0.2
- Fix formatting for puppetforge's markdown interpreter (version bump needed to push to puppetforge)

### v2.0.1
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
