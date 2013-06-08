# Depending on puppet version, this feature may or may not include the libraries needed, but
# if some of them are present, the others should be too. This check prevents errors from 
# non Windows nodes that have had this module pluginsynced to them. 
if Puppet.features.microsoft_windows?
  require 'win32/registry.rb' 
  require 'Win32API'  
  module Win32
    class Registry
      KEY_WOW64_64KEY = 0x0100 unless defined?(KEY_WOW64_64KEY)
    end
  end
end

Puppet::Type.type(:windows_env).provide(:windows_env) do
  desc "Manage Windows environment variables"

  confine :osfamily => :windows
  defaultfor :osfamily => :windows

  # http://msdn.microsoft.com/en-us/library/windows/desktop/ms681382%28v=vs.85%29.aspx
  self::ERROR_FILE_NOT_FOUND = 2

  # This feature check is necessary to make 'puppet module build' work, since
  # it actually executes this code in building.
  if Puppet.features.microsoft_windows?
    self::REG_HIVE = Win32::Registry::HKEY_LOCAL_MACHINE
    self::REG_PATH = 'System\CurrentControlSet\Control\Session Manager\Environment'
    # see broadcast_changes method for more info about SendMessageTimeout
    self::SendMessageTimeout = Win32API.new('user32', 'SendMessageTimeout', 'LLLPLLP', 'L')
  end

  def exists?
    if @resource[:ensure] == :present && [nil, :nil].include?(@resource[:value])
      self.fail "'value' parameter must be provided when 'ensure => present'"
    end
    if @resource[:ensure] == :absent && [nil, :nil].include?(@resource[:value]) && 
      [:prepend, :append, :insert].include?(@resource[:mergemode])
      self.fail "'value' parameter must be provided when 'ensure => absent' and 'mergemode => #{@resource[:mergemode]}'"
    end

    @sep = @resource[:separator]

    @reg_types = { :REG_SZ => Win32::Registry::REG_SZ, :REG_EXPAND_SZ => Win32::Registry::REG_EXPAND_SZ }
    @reg_type = @reg_types[@resource[:type]]

    if @resource[:value].class != Array
      @resource[:value] = [@resource[:value]]
    end

    begin
      # key.read returns '[type, data]' and must be used instead of [] because [] expands %variables%. 
      self.class::REG_HIVE.open(self.class::REG_PATH) { |key| @value = key.read(@resource[:variable])[1] } 
    rescue Win32::Registry::Error => error
      if error.code == self.class::ERROR_FILE_NOT_FOUND
        debug "Environment variable #{@resource[:variable]} not found"
        return false
      end
      reg_fail('reading', error)
    end

    @value = @value.split(@sep)

    # Assume that if the user says 'ensure => absent', they want the value to
    # be removed regardless of its position, i.e. use the 'insert' behavior
    # when removing in 'prepend' and 'append' modes. Otherwise, if the value
    # were in the variable but not at the beginning (prepend) or end (append),
    # it would not be removed. 
    if @resource[:ensure] == :absent && [:append, :prepend].include?(@resource[:mergemode])
      @resource[:mergemode] = :insert
    end

    case @resource[:mergemode]
    when :clobber
      # When 'ensure == absent' in clobber mode, we delete the variable itself, regardless of its content, so
      # don't bother checking the content in this case. 
      @resource[:ensure] == :present ? @value == @resource[:value] : true
    when :insert
      # verify all elements are present and they appear in the correct order
      indexes = @resource[:value].map { |x| @value.find_index { |y| x.casecmp(y) == 0 } }
      if indexes.count == 1
        indexes == [nil] ? false : true
      else
        indexes.each_cons(2).all? { |a, b| a && b && a < b }
      end
    when :append
      @value.map { |x| x.downcase }[(-1 * @resource[:value].count)..-1] == @resource[:value].map { |x| x.downcase }
    when :prepend
      @value.map { |x| x.downcase }[0..(@resource[:value].count - 1)] == @resource[:value].map { |x| x.downcase }
    end
  end

  def create
    debug "Creating or inserting value into environment variable '#{@resource[:variable]}'"

    # If the registry item doesn't exist yet, creation is always treated like
    # clobber mode, i.e. create the new reg item and populate it with
    # @resource[:value]
    if not @value
      @resource[:mergemode] = :clobber
    end

    case @resource[:mergemode]
    when :clobber
      @reg_type = Win32::Registry::REG_SZ unless @reg_type
      begin
        self.class::REG_HIVE.create(self.class::REG_PATH, Win32::Registry::KEY_ALL_ACCESS | Win32::Registry::KEY_WOW64_64KEY) do |key| 
          key[@resource[:variable], @reg_type] = @resource[:value].join(@sep) 
        end
      rescue Win32::Registry::Error => error
        reg_fail('creating', error)
      end
    # the position at which the new value will be inserted when using insert is
    # arbitrary, so may as well group it with append.
    when :insert, :append
      # delete if already in the string and move to end.
      remove_value
      @value = @value.concat(@resource[:value])
      key_write
    when :prepend
      # delete if already in the string and move to front
      remove_value
      @value = @resource[:value].concat(@value)
      key_write
    end
    broadcast_changes
  end

  def destroy
    debug "Removing value from environment variable '#{@resource[:variable]}', or removing variable itself"
    case @resource[:mergemode]
    when :clobber
      key_write { |key| key.delete_value(@resource[:variable]) }
    when :insert, :append, :prepend
      remove_value
      key_write
    end
    broadcast_changes
  end

  def type
    # QueryValue returns '[type, value]'
     current_type = self.class::REG_HIVE.open(self.class::REG_PATH) { |key| Win32::Registry::API.QueryValue(key.hkey, @resource[:variable]) }[0]
     @reg_types.invert[current_type]
  end

  def type=(newtype)
    newtype = @reg_types[newtype]
    key_write { |key| key[@resource[:variable], newtype] = @value.join(@sep) }
    broadcast_changes
  end

  private

  def reg_fail(action, error)
    self.fail "#{action} '#{self.class::REG_HIVE.name}:\\#{self.class::REG_PATH}\\#{@resource[:variable]}' returned error #{error.code}: #{error.message}"
  end

  def remove_value
    @value = @value.delete_if { |x| @resource[:value].find { |y| y.casecmp(x) == 0 } }
  end

  def key_write(&block)
    unless block_given?
      if ! [nil, :nil, :undef].include?(@resource[:type]) && self.type != @resource[:type]
        # It may be the case that #exists? returns false, but we're still not creating a
        # new registry value (e.g. when mergmode => insert). In this case, the property getters/setters
        # won't be called, so we'll go ahead and set type here manually. 
        newtype = @reg_types[@resource[:type]]
      else
        newtype = @reg_types[self.type]
      end
        block = proc { |key| key[@resource[:variable], newtype] = @value.join(@sep) }
    end
    self.class::REG_HIVE.open(self.class::REG_PATH, Win32::Registry::KEY_WRITE | Win32::Registry::KEY_WOW64_64KEY, &block) 
  rescue Win32::Registry::Error => error
    reg_fail('writing', error)
  end

  # Make new variable visible without logging off and on again.
  #
  # see: http://stackoverflow.com/questions/190168/persisting-an-environment-variable-through-ruby/190437#190437
  # and: http://msdn.microsoft.com/en-us/library/windows/desktop/ms644952%28v=vs.85%29.aspx
  # and: http://msdn.microsoft.com/en-us/library/windows/desktop/ms725497%28v=vs.85%29.aspx
  # and for good measure: http://ruby-doc.org/stdlib-1.9.2/libdoc/dl/rdoc/Win32API.html
  def broadcast_changes
    debug "Broadcasting changes to environment"
    # About the args:
    # 0xFFFF        = HWND_BROADCAST (send to all windows)
    # 0x001A        = WM_SETTINGCHANGE (the message to send, informs windows a system change has occurred)
    # 0             = NULL (this should always be NULL with WM_SETTINGCHANGE)
    # 'Environment' = (string indicating what changed. This refers to the 'Environment' registry key)
    # 2             = SMTO_ABORTIFHUNG (return without waiting timeout period if receiver appears to hang)
    # bcast timeout = (How long to wait for a window to respond to the event. Each window gets this amount of time)
    # 0             = (Return value. We're ignoring it)
    self.class::SendMessageTimeout.call(0xFFFF, 0x001A, 0, 'Environment', 2, @resource[:broadcast_timeout], 0)
  end    
end
