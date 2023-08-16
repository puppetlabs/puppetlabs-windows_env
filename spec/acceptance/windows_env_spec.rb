# frozen_string_literal: true

require 'spec_helper_acceptance'

RSpec.configure do |c|
  c.before(:suite) do
    pp = <<~PP
      windows_env { 'REPO=puppetlabs':
        mergemode => clobber,
      }

      windows_env { 'puppetlabs':
        variable  => 'PATH',
        value     => 'puppetlabs',
        mergemode => insert,
      }
    PP
    Helper.instance.apply_manifest(pp, catch_failures: true)
  end
end

RSpec.describe 'windows_env' do
  context 'creating system env variable' do
    result = Helper.instance.run_shell('[Environment]::GetEnvironmentVariables("Machine").REPO')
    it { expect(result.exit_status).to eq(0) }
  end

  context 'updating PATH env variable' do
    result = Helper.instance.run_shell('[Environment]::GetEnvironmentVariables("Machine").Path')
    it { expect(result.exit_status).to eq(0) }
  end
end
