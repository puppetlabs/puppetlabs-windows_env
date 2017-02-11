#!/usr/bin/env ruby

require 'spec_helper'

describe Puppet::Type.type(:windows_env) do

  before do
    @class = described_class
    @provider_class = @class.provide(:fake) { mk_resource_methods }
    @provider = @provider_class.new
    @resource = stub 'resource', :resource => nil, :provider => @provider

    @class.stubs(:defaultprovider).returns @provider_class
    @class.any_instance.stubs(:provider).returns @provider
  end

  let(:keyattribute) { [:variable, :value, :user] }

  it "should have a key attribute" do
    expect(@class.key_attributes).to eq(keyattribute)
  end

  describe "when validating attributes" do

    params = [
      :variable,
      :value,
      :user,
      :mergemode,
      :separator,
      :broadcast_timeout,
    ]

    properties = [
      :type,
    ]

    params.each do |param|
      it "should have a #{param} parameter" do
        expect(@class.attrtype(param)).to eq(:param)
      end
    end

    properties.each do |param|
      it "should have a #{param} property" do
        expect(@class.attrtype(param)).to eq(:property)
      end
    end

  end

end








