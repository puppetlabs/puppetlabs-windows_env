Puppet::Type.newtype(:windows_env) do
  desc 'Manages Windows environment variables'

  # Track resources that are managing the same environment variable so we can
  # detect mergemode/type conflicts
  @mergemode = {}
  @type = {}
  def self.check_collisions(resource)
    user = resource[:user] || :SYSTEM
    var = resource[:variable].downcase

    # Cannot have two resources in clobber mode on the same var
    @mergemode[user] ||= {}
    last = @mergemode[user][var]
    raise "Multiple resources are managing the same environment variable but at least one is in clobber mergemode. (Offending resources: #{resource}, #{last})" if (!last.nil? && last.catalog == resource.catalog) && ((resource[:mergemode] == :clobber && last) || (last && last[:mergemode] == :clobber))
    @mergemode[user][var] = resource

    # Cannot have two resources with different types on the same var
    return if [nil, :undef].include?(resource[:type])

    @type[user] ||= {}
    last = @type[user][var]
    raise "Multiple resources are managing the same environment variable but their types do not agree (Offending resources: #{resource}, #{last})" if last && last[:type] != resource[:type]
    @type[user][var] = resource
  end

  # title will look like "#{variable}=#{value}" (The '=' is not permitted in
  # environment variable names). If no '=' is present, user is giving only
  # the variable name (for deletion purposes, say, or to provide an array),
  # so value will be set to nil (and possibly overridden later).
  def self.title_patterns
    [[%r{^(.*?)=(.*)$}, [[:variable], [:value]]],
     [%r{^([^=]+)$}, [[:variable]]]]
  end

  ensurable do
    newvalue(:present) { provider.create }
    newvalue(:absent) { provider.destroy }
    defaultto(:present)
  end

  newparam(:variable) do
    desc 'The environment variable name'
    isnamevar
  end

  newparam(:value) do
    desc 'The environment variable value'
    isnamevar

    munge do |val|
      if val.class != Array
        [val]
      else
        val
      end
    end
  end

  newparam(:user) do
    desc 'Set the user whose environment will be modified'
    isnamevar
  end

  newparam(:mergemode) do
    desc 'How to set the value of the environment variable. E.g. replace existing value, append to existing value...'
    newvalues(:clobber, :insert, :append, :prepend)
    defaultto(:insert)
  end

  newparam(:separator) do
    desc 'How to separate environment variables with multiple values (e.g. PATH)'
    defaultto(';')
  end

  newparam(:broadcast_timeout) do
    desc 'Set the timeout (in ms) for environment refreshes. This is per top level window, so delay may be longer than provided value.'
    validate do |val|
      begin
        val = Integer(val)
        val > 0 || raise(ArgumentError)
      rescue ArgumentError
        raise ArgumentError, 'broadcast_timeout must be a valid positive integer'
      end
    end
    munge { |val| Integer(val) }
    defaultto(100)
  end

  newproperty(:type) do
    desc "What type of registry key to use for the variable. Determines whether interpolation of '%' enclosed names will occur"
    newvalues(:REG_SZ, :REG_EXPAND_SZ)
  end

  validate do
    if self[:ensure] == :present && [nil, :undef].include?(self[:value])
      raise "'value' parameter must be provided when 'ensure => present'"
    end
    if self[:ensure] == :absent && [nil, :undef].include?(self[:value]) &&
       [:prepend, :append, :insert].include?(self[:mergemode])
      raise "'value' parameter must be provided when 'ensure => absent' and 'mergemode => #{self[:mergemode]}'"
    end

    self.class.check_collisions(self)
  end
end
