require 'puppet/util/feature'
# This file might seem like it should be called 'ffi.rb'. Little bit of
# discussion here:
# https://groups.google.com/forum/#!topic/puppet-dev/I6YMtNHmykU
Puppet.features.add(:windows_env, :libs => ['ffi'])
