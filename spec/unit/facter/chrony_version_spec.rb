require 'spec_helper'
require 'facter'

describe :chrony_version, :type => :fact do

  before :all do
    # perform any action that should be run for the entire test suite
  end

  before :each do
    # perform any action that should be run before every test
    Facter.clear
    # This will mock the facts that confine uses to limit facts running under certain conditions
    allow(Facter.fact(:kernel)).to receive(:value).and_return(:linux)

  end

  it 'should return a value' do
    expect(Facter.fact(:chrony_version).value).not_to be_nil
  end
end
