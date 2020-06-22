# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.0.1](https://github.com/voxpupuli/puppet-windows_env/tree/v4.0.1) (2020-06-22)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- Fix: Could not set 'present' on ensure: uninitialized constant Win32::Registry::KEY\_WOW64\_64KEY [\#70](https://github.com/voxpupuli/puppet-windows_env/pull/70) ([cmchoi2000](https://github.com/cmchoi2000))

## [v4.0.0](https://github.com/voxpupuli/puppet-windows_env/tree/v4.0.0) (2020-05-10)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v3.2.0...v4.0.0)

**Breaking changes:**

- modulesync 2.7.0 and drop puppet 4 [\#60](https://github.com/voxpupuli/puppet-windows_env/pull/60) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Add a set of domain related facts [\#61](https://github.com/voxpupuli/puppet-windows_env/issues/61)
- Update Readme and remove references to badgerious [\#31](https://github.com/voxpupuli/puppet-windows_env/issues/31)

**Merged pull requests:**

- Fixed github url in README.md [\#64](https://github.com/voxpupuli/puppet-windows_env/pull/64) ([skrysmanski](https://github.com/skrysmanski))
- Remove Linux acceptance nodesets [\#57](https://github.com/voxpupuli/puppet-windows_env/pull/57) ([ekohl](https://github.com/ekohl))

## [v3.2.0](https://github.com/voxpupuli/puppet-windows_env/tree/v3.2.0) (2018-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v3.1.1...v3.2.0)

**Implemented enhancements:**

- \(FACT-1346\) Add default Windows facts as a custom fact [\#54](https://github.com/voxpupuli/puppet-windows_env/pull/54) ([glennsarti](https://github.com/glennsarti))

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#55](https://github.com/voxpupuli/puppet-windows_env/pull/55) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.1](https://github.com/voxpupuli/puppet-windows_env/tree/v3.1.1) (2018-09-07)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v3.1.0...v3.1.1)

**Merged pull requests:**

- Remove docker nodesets [\#49](https://github.com/voxpupuli/puppet-windows_env/pull/49) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-windows_env/tree/v3.1.0) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v3.0.0...v3.1.0)

**Merged pull requests:**

- bump puppet to latest supported version 4.10.0 [\#46](https://github.com/voxpupuli/puppet-windows_env/pull/46) ([bastelfreak](https://github.com/bastelfreak))
- rework README.md [\#45](https://github.com/voxpupuli/puppet-windows_env/pull/45) ([bastelfreak](https://github.com/bastelfreak))
- Fix title patterns to not use unsupported proc [\#43](https://github.com/voxpupuli/puppet-windows_env/pull/43) ([treydock](https://github.com/treydock))

## [v3.0.0](https://github.com/voxpupuli/puppet-windows_env/tree/v3.0.0) (2017-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.3.0...v3.0.0)

**Closed issues:**

- Issue with setting env variables that have multiple values separated by ";" [\#30](https://github.com/voxpupuli/puppet-windows_env/issues/30)
- Puppet approved [\#20](https://github.com/voxpupuli/puppet-windows_env/issues/20)

**Merged pull requests:**

- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#40](https://github.com/voxpupuli/puppet-windows_env/pull/40) ([bastelfreak](https://github.com/bastelfreak))
- Removing non-windows nodesets. [\#36](https://github.com/voxpupuli/puppet-windows_env/pull/36) ([TraGicCode](https://github.com/TraGicCode))

## [v2.3.0](https://github.com/voxpupuli/puppet-windows_env/tree/v2.3.0) (2017-02-12)

This is the last release with Puppet3 support!
* Fix: Check for clobber issues within a single catalog
* Add some basic type testing
* Modulesync
* Cleanup codebase

### v2.2.2

- Updates for Puppet 4 / Ruby 2.1.5 compatibility.

### v2.2.1

- Fixes to prevent autoloading on master from failing

## v2.2.0

- Puppet 3.7 / Ruby 64 bit compatibility changes.

## v2.1.0

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

## v2.0.0

- Remove 'manifests' directory. This directory had nothing useful in it.
- Fixed name in Modulefile (was erroneously 'badgerious-puppet_env' now is 'badgerious-windows_env').
- Add 'user' parameter to allow user specific variables to be managed.
- Changed default 'broadcast_timeout' to 100ms. Puppet usually runs in the background, where the broadcasting
  doesn't work anyway. There's no reason to be waiting for updates to go through that won't affect any users.

## v1.0.0

- Ensure now defaults to 'present'.
- New parameter added, 'type'. Allows selection between REG_SZ or REG_EXPAND_SZ registry keys.


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
