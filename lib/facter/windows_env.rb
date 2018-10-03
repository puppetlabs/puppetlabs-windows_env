Facter.add('windows_env') do
  confine osfamily: :windows
  setcode do
    require 'puppet/util/windows/process'

    # This list must be in uppercase
    whitelist = %w[
      ALLUSERSPROFILE
      APPDATA
      COMMONPROGRAMFILES
      COMMONPROGRAMFILES(X86)
      HOME
      HOMEDRIVE
      HOMEPATH
      LOCALAPPDATA
      PATHEXT
      PROCESSOR_IDENTIFIER
      PROCESSOR_LEVEL
      PROCESSOR_REVISION
      PROGRAMDATA
      PROGRAMFILES
      PROGRAMFILES(X86)
      PSMODULEPATH
      PUBLIC
      SYSTEMDRIVE
      SYSTEMROOT
      TEMP
      TMP
      USERPROFILE
      WINDIR
    ]

    result = {}
    env_hash = Puppet::Util::Windows::Process.get_environment_strings
    env_hash.keys.
      select { |key| whitelist.include?(key.upcase) }.
      each { |key| result[key.upcase] = env_hash[key] }
    result
  end
end
