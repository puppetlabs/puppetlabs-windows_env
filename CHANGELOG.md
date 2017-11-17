# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.0.0](https://github.com/voxpupuli/puppet-windows_env/tree/v3.0.0) (2017-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.3.0...v3.0.0)

**Closed issues:**

- Issue with setting env variables that have multiple values separated by ";" [\#30](https://github.com/voxpupuli/puppet-windows_env/issues/30)
- Puppet approved [\#20](https://github.com/voxpupuli/puppet-windows_env/issues/20)

**Merged pull requests:**

- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#40](https://github.com/voxpupuli/puppet-windows_env/pull/40) ([bastelfreak](https://github.com/bastelfreak))
- Removing non-windows nodesets. [\#36](https://github.com/voxpupuli/puppet-windows_env/pull/36) ([TraGicCode](https://github.com/TraGicCode))

## [v2.3.0](https://github.com/voxpupuli/puppet-windows_env/tree/v2.3.0) (2017-02-12)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.2.2...v2.3.0)

**Fixed bugs:**

- Check for clobber issues within a single catalog [\#27](https://github.com/voxpupuli/puppet-windows_env/pull/27) ([igalic](https://github.com/igalic))

**Closed issues:**

- License - What type is it? [\#19](https://github.com/voxpupuli/puppet-windows_env/issues/19)
- Values with trailing slash do not include trailing slash [\#15](https://github.com/voxpupuli/puppet-windows_env/issues/15)
- Prepend, type REG\_EXPAND\_SZ seems to constantly add to PATH [\#13](https://github.com/voxpupuli/puppet-windows_env/issues/13)
- Upcoming Puppet 4 / Ruby 2.1.5 Registry compatibility changes [\#8](https://github.com/voxpupuli/puppet-windows_env/issues/8)

**Merged pull requests:**

- release 2.3.0 [\#26](https://github.com/voxpupuli/puppet-windows_env/pull/26) ([bastelfreak](https://github.com/bastelfreak))
- Set min Puppet version\_requirement, namespace fix [\#23](https://github.com/voxpupuli/puppet-windows_env/pull/23) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Adds some basic type testing [\#18](https://github.com/voxpupuli/puppet-windows_env/pull/18) ([petems](https://github.com/petems))

## [v2.2.2](https://github.com/voxpupuli/puppet-windows_env/tree/v2.2.2) (2015-08-08)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.2.1...v2.2.2)

**Closed issues:**

- How to avoid duplicates? [\#10](https://github.com/voxpupuli/puppet-windows_env/issues/10)
- "Fixes to prevent autoloading on master from failing" don't work [\#9](https://github.com/voxpupuli/puppet-windows_env/issues/9)
- Could not autoload puppet/type/windows\_env [\#7](https://github.com/voxpupuli/puppet-windows_env/issues/7)

## [v2.2.1](https://github.com/voxpupuli/puppet-windows_env/tree/v2.2.1) (2014-11-07)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.2.0...v2.2.1)

**Closed issues:**

- Upcoming Puppet 3.7 / PE 3.4 x64 compatibility changes [\#6](https://github.com/voxpupuli/puppet-windows_env/issues/6)

## [v2.2.0](https://github.com/voxpupuli/puppet-windows_env/tree/v2.2.0) (2014-08-30)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.1.0...v2.2.0)

## [v2.1.0](https://github.com/voxpupuli/puppet-windows_env/tree/v2.1.0) (2014-05-28)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.0.2...v2.1.0)

**Closed issues:**

- PE 3.2 Error: Downloaded release for badgerious-windows\_env did not match expected checksum [\#4](https://github.com/voxpupuli/puppet-windows_env/issues/4)

## [v2.0.2](https://github.com/voxpupuli/puppet-windows_env/tree/v2.0.2) (2013-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.0.1...v2.0.2)

## [v2.0.1](https://github.com/voxpupuli/puppet-windows_env/tree/v2.0.1) (2013-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v2.0.0...v2.0.1)

**Implemented enhancements:**

- User variables [\#3](https://github.com/voxpupuli/puppet-windows_env/issues/3)

## [v2.0.0](https://github.com/voxpupuli/puppet-windows_env/tree/v2.0.0) (2013-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/v1.0.0...v2.0.0)

**Implemented enhancements:**

- Allow REG\_EXPAND\_SZ variables to be created [\#1](https://github.com/voxpupuli/puppet-windows_env/issues/1)

## [v1.0.0](https://github.com/voxpupuli/puppet-windows_env/tree/v1.0.0) (2013-06-08)

[Full Changelog](https://github.com/voxpupuli/puppet-windows_env/compare/a91a72527f915eae4633da87e898fd99b632cd52...v1.0.0)

**Fixed bugs:**

- Ensure relative ordering when 'mergemode =\> insert' [\#2](https://github.com/voxpupuli/puppet-windows_env/issues/2)

# Changelog

## 2017-02-12 Release 2.3.0

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


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*