#!/usr/bin/env ruby

require 'spec_helper'

describe Puppet::Type.type(:windows_env) do
  let(:type) { described_class }
  let(:keyattribute) { [:variable, :value, :user] }

  it 'has a key attribute' do
    expect(type.key_attributes).to eq(keyattribute)
  end

  describe 'when validating attributes' do
    params = [
      :variable,
      :value,
      :user,
      :mergemode,
      :separator,
      :broadcast_timeout
    ]

    properties = [
      :type
    ]

    params.each do |param|
      it "should have a #{param} parameter" do
        expect(type.attrtype(param)).to eq(:param)
      end
    end

    properties.each do |param|
      it "should have a #{param} property" do
        expect(type.attrtype(param)).to eq(:property)
      end
    end
  end
end
