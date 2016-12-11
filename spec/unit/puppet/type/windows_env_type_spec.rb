require 'spec_helper'
require 'puppet/type/windows_env'

describe Puppet::Type.type(:windows_env) do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k,v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'when validating attributes' do
        [ :variable, :value, :user ].each do |param|
          it "should have a #{param} parameter" do
            expect(described_class.attrtype(param)).to eq(:param)
          end
        end
      end
    end
  end
end
